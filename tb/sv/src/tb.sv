`timescale 1ns/1ns

module tb;

  localparam  int         period_p  = 10; // 100MHz

  localparam  int         MEM_DW    = 8;      // 8 bits mem data.
  localparam  int         MEM_AW    = 4;      // 4 bits mem adress (depth = 16)

  localparam  int         FIFO_DW     = 8;      // 8 bits fifo data.
  localparam  int         FIFO_DEPTH  = 4;      // 4 pos fifo depth

  logic                   clk = 1'b0;
  logic                   rst_n = 1'b0;
  logic                   mem_wr    = 1'b0;
  logic [MEM_DW-1:0]      mem_din   = '0;
  logic [MEM_DW-1:0]      mem_dout;
  logic [MEM_AW-1:0]      mem_wa    = '0;
  logic [MEM_AW-1:0]      mem_ra    = '0;
  logic                   fifo_re   = 1'b0;
  logic                   fifo_we   = 1'b0;
  logic                   fifo_full;
  logic                   fifo_empty;
  logic [FIFO_DW-1:0]     fifo_din  = '0;
  logic [FIFO_DW-1:0]     fifo_dout;

  task automatic a_task;
    $display("[%0t] Entering a_task",$time);
    #10;
    $display("[%0t] Exiting a_task",$time);
  endtask

  always #(period_p/2) clk <= ~clk;

  initial begin
    $display("[%0t] Starting sim",$time);
    $dumpfile("tb.vcd");
    $dumpvars(0,tb);
    rst_n = 1'b1;
    #(3*period_p);
    rst_n = 1'b0;
    #(3*period_p);
    rst_n = 1'b1;
    repeat (10) @(posedge clk);
    @(posedge clk);
    repeat (3) @(posedge clk);
    repeat (3) begin
      repeat (7) @(posedge clk);
      mem_din = mem_din + 1;
      #1 mem_wr = 1'b1;
      @(posedge clk);
      #1 mem_wr = 1'b0;
      mem_wr = 1'b0;
      mem_wa = mem_wa + 1;
    end
    repeat (3) @(posedge clk);
    repeat (3) begin
      @(posedge clk);
      mem_ra = mem_ra + 1;
    end
    repeat (FIFO_DEPTH+1) begin
      repeat (7) @(posedge clk);
      fifo_din = fifo_din + 1;
      #1 fifo_we = 1'b1;
      @(posedge clk);
      #1 fifo_we = 1'b0;
    end
    repeat (FIFO_DEPTH+1) begin
      repeat (7) @(posedge clk);
      #1 fifo_re = 1'b1;
      @(posedge clk);
      #1 fifo_re = 1'b0;
    end
    $display("[%0t] Finishing sim",$time);
    $finish;
  end

  mem_dp #(
    .DW       (MEM_DW),
    .AW       (MEM_AW)
  ) mem_dp_dut (
    .clk        ( clk ),
    .wr         ( mem_wr ),
    .wa         ( mem_wa ),
    .ra         ( mem_ra ),
    .din        ( mem_din ),
    .dout       ( mem_dout )
  );

  fifo_scd #(
    .DW       (FIFO_DW),
    .DEPTH    (FIFO_DEPTH)
  ) fifo_scd_dut (
    .clk        ( clk ),
    .rst_n      ( rst_n ),
    .re         ( fifo_re ),
    .we         ( fifo_we ),
    .din        ( fifo_din ),
    .dout       ( fifo_dout ),
    .full       ( fifo_full ),
    .empty      ( fifo_empty )
  );

endmodule
