module ahb_master_lite_single #(
    parameter int ADDR_W = 32,
    parameter int DATA_W = 32,
    parameter int CMD_W  = ADDR_W + 1 + 3 + 3 + 4 + 4
) (
    input  logic              HCLK,
    input  logic              HRESETn,

    // -------------------------------
    // Command FIFO interface
    // data format (MSB->LSB):
    // {cmd_addr, cmd_write, cmd_size, cmd_burst, cmd_len, cmd_prot}
    // -------------------------------
    input  logic              cmd_fifo_empty,
    input  logic              cmd_fifo_full,
    input  logic [CMD_W-1:0]  cmd_fifo_data,
    output logic              cmd_fifo_rd,

    // -------------------------------
    // Write-data FIFO interface
    // -------------------------------
    input  logic              wdata_fifo_empty,
    input  logic              wdata_fifo_full,
    input  logic [DATA_W-1:0] wdata_fifo_data,
    output logic              wdata_fifo_rd,

    // -------------------------------
    // Read-data output (no backpressure)
    // -------------------------------
    output logic              rdata_valid,
    output logic [DATA_W-1:0] rdata,
    output logic              rdata_err,

    // -------------------------------
    // AHB-Lite master interface
    // -------------------------------
    output logic [ADDR_W-1:0] HADDR,
    output logic [1:0]        HTRANS,
    output logic              HWRITE,
    output logic [2:0]        HSIZE,
    output logic [2:0]        HBURST,
    output logic [3:0]        HPROT,
    output logic [DATA_W-1:0] HWDATA,
    output logic              HMASTLOCK,

    input  logic [DATA_W-1:0] HRDATA,
    input  logic              HREADY,
    input  logic              HRESP
);

    localparam logic [1:0] HTRANS_IDLE   = 2'b00;
    localparam logic [1:0] HTRANS_NONSEQ = 2'b10;
    localparam logic [1:0] HTRANS_SEQ    = 2'b11;

    localparam int PROT_LSB  = 0;
    localparam int LEN_LSB   = PROT_LSB + 4;
    localparam int BURST_LSB = LEN_LSB + 4;
    localparam int SIZE_LSB  = BURST_LSB + 3;
    localparam int WRITE_LSB = SIZE_LSB + 3;
    localparam int ADDR_LSB  = WRITE_LSB + 1;

    logic [ADDR_W-1:0] cmd_addr;
    logic              cmd_write;
    logic [2:0]        cmd_size;
    logic [2:0]        cmd_burst;
    logic [3:0]        cmd_len;
    logic [3:0]        cmd_prot;

    assign cmd_prot  = cmd_fifo_data[PROT_LSB +: 4];
    assign cmd_len   = cmd_fifo_data[LEN_LSB  +: 4];
    assign cmd_burst = cmd_fifo_data[BURST_LSB+: 3];
    assign cmd_size  = cmd_fifo_data[SIZE_LSB +: 3];
    assign cmd_write = cmd_fifo_data[WRITE_LSB];
    assign cmd_addr  = cmd_fifo_data[ADDR_LSB +: ADDR_W];

    logic              active;
    logic [ADDR_W-1:0] addr_q;
    logic              write_q;
    logic [2:0]        size_q;
    logic [2:0]        burst_q;
    logic [3:0]        prot_q;
    logic              first_q;
    logic [4:0]        beats_left_q;
    logic [ADDR_W-1:0] wrap_base_q;
    logic [ADDR_W-1:0] wrap_mask_q;

    logic [DATA_W-1:0] wdata_pipe_q;
    logic              dphase_read_pending_q;

    function automatic logic [4:0] burst_beats(input logic [2:0] burst, input logic [3:0] len);
        begin
            unique case (burst)
                3'b000: burst_beats = 5'd1;
                3'b001: burst_beats = {1'b0, len} + 5'd1;
                3'b010,
                3'b011: burst_beats = 5'd4;
                3'b100,
                3'b101: burst_beats = 5'd8;
                3'b110,
                3'b111: burst_beats = 5'd16;
                default: burst_beats = 5'd1;
            endcase
        end
    endfunction

    function automatic logic is_wrap_burst(input logic [2:0] burst);
        begin
            is_wrap_burst = (burst == 3'b010) || (burst == 3'b100) || (burst == 3'b110);
        end
    endfunction

    logic [ADDR_W-1:0] beat_bytes;
    logic              write_data_avail;
    logic              transfer_valid;
    logic              transfer_fire;
    logic              done_this_beat;
    logic              cmd_available;
    logic              cmd_take;
    logic              slot_open;
    logic              prefetch_same_burst;
    logic              prefetch_back2back;
    logic              prefetch_from_idle;

    assign beat_bytes       = {{(ADDR_W-1){1'b0}}, 1'b1} << size_q;
    assign write_data_avail = ~wdata_fifo_empty;
    assign transfer_valid   = active & ((~write_q) | write_data_avail);
    assign transfer_fire    = transfer_valid & HREADY;
    assign done_this_beat   = transfer_fire & (beats_left_q == 5'd1);

    assign cmd_available = ~cmd_fifo_empty;
    assign slot_open     = (~active) | done_this_beat;
    assign cmd_take      = slot_open & cmd_available & ((~cmd_write) | write_data_avail);
    assign cmd_fifo_rd   = cmd_take;

    // prefetch write data for:
    // 1) next beat of current write burst,
    // 2) back-to-back next write command when current beat is the last one,
    // 3) first write command taken from idle.
    assign prefetch_same_burst = active & write_q & transfer_fire & (beats_left_q > 5'd1);
    assign prefetch_back2back  = active & write_q & done_this_beat & cmd_take & cmd_write;
    assign prefetch_from_idle  = (~active) & cmd_take & cmd_write;
    assign wdata_fifo_rd       = prefetch_same_burst | prefetch_back2back | prefetch_from_idle;

    assign HADDR      = addr_q;
    assign HTRANS     = transfer_valid ? (first_q ? HTRANS_NONSEQ : HTRANS_SEQ) : HTRANS_IDLE;
    assign HWRITE     = write_q;
    assign HSIZE      = size_q;
    assign HBURST     = burst_q;
    assign HPROT      = prot_q;
    assign HWDATA     = wdata_pipe_q;
    assign HMASTLOCK  = 1'b0;

    always_ff @(posedge HCLK or negedge HRESETn) begin
        logic [4:0]        n_beats;
        logic [ADDR_W-1:0] n_wrap_bytes;
        logic [ADDR_W-1:0] addr_off;

        if (!HRESETn) begin
            active                <= 1'b0;
            addr_q                <= '0;
            write_q               <= 1'b0;
            size_q                <= 3'b010;
            burst_q               <= 3'b000;
            prot_q                <= 4'b0011;
            first_q               <= 1'b1;
            beats_left_q          <= 5'd0;
            wrap_base_q           <= '0;
            wrap_mask_q           <= '0;
            wdata_pipe_q          <= '0;
            dphase_read_pending_q <= 1'b0;
            rdata_valid           <= 1'b0;
            rdata                 <= '0;
            rdata_err             <= 1'b0;
        end else begin
            rdata_valid <= 1'b0;
            if (HREADY && dphase_read_pending_q) begin
                rdata_valid <= 1'b1;
                rdata       <= HRDATA;
                rdata_err   <= HRESP;
            end
            if (HREADY) begin
                dphase_read_pending_q <= transfer_fire & (~write_q);
            end

            if (wdata_fifo_rd) begin
                wdata_pipe_q <= wdata_fifo_data;
            end

            if (active && transfer_fire && (beats_left_q > 5'd1)) begin
                first_q      <= 1'b0;
                beats_left_q <= beats_left_q - 5'd1;

                if (is_wrap_burst(burst_q)) begin
                    addr_off = (addr_q - wrap_base_q) + beat_bytes;
                    addr_q   <= wrap_base_q | (addr_off & wrap_mask_q);
                end else begin
                    addr_q <= addr_q + beat_bytes;
                end
            end

            if (slot_open) begin
                if (cmd_take) begin
                    n_beats = burst_beats(cmd_burst, cmd_len);

                    active       <= 1'b1;
                    addr_q       <= cmd_addr;
                    write_q      <= cmd_write;
                    size_q       <= cmd_size;
                    burst_q      <= cmd_burst;
                    prot_q       <= cmd_prot;
                    first_q      <= 1'b1;
                    beats_left_q <= n_beats;

                    n_wrap_bytes = ({{(ADDR_W-1){1'b0}}, 1'b1} << cmd_size) * n_beats;
                    wrap_base_q  <= cmd_addr & (~(n_wrap_bytes - 1'b1));
                    wrap_mask_q  <= n_wrap_bytes - 1'b1;
                end else begin
                    active <= 1'b0;
                end
            end
        end
    end

    // keep *_full visible for integration sanity (currently unused by this read-side module)
    wire _unused_ok = &{1'b0, cmd_fifo_full, wdata_fifo_full};

endmodule
