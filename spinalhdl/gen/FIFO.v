// Generator : SpinalHDL v1.10.2a    git head : a348a60b7e8b6a455c72e1536ec3d74a2ea16935
// Component : FIFO
// Git hash  : f3e089f87419ad1fd6dea5f01f66e430e60b1cf2

`timescale 1ns/1ps

module FIFO (
  input  wire [15:0]   i_port_vdata_data,
  input  wire          i_port_vdata_valid,
  output wire          i_port_ready,
  output wire [15:0]   o_port_vdata_data,
  output wire          o_port_vdata_valid,
  input  wire          o_port_ready,
  input  wire          clk,
  input  wire          reset
);

  wire       [15:0]   rctrl_o_mem_data;
  reg        [15:0]   mem_spinal_port1;
  wire                wctrl_i_port_ready;
  wire       [4:0]    wctrl_o_mem_addr;
  wire       [15:0]   wctrl_o_mem_data;
  wire                wctrl_o_mem_en;
  wire       [5:0]    wctrl_o_addr;
  wire       [15:0]   rctrl_o_port_vdata_data;
  wire                rctrl_o_port_vdata_valid;
  wire       [4:0]    rctrl_o_mem_addr;
  wire                rctrl_o_mem_en;
  wire       [5:0]    rctrl_o_addr;
  reg [15:0] mem [0:31];

  always @(posedge clk) begin
    if(wctrl_o_mem_en) begin
      mem[wctrl_o_mem_addr] <= wctrl_o_mem_data;
    end
  end

  always @(posedge clk) begin
    if(rctrl_o_mem_en) begin
      mem_spinal_port1 <= mem[rctrl_o_mem_addr];
    end
  end

  WrCntr wctrl (
    .i_port_vdata_data  (i_port_vdata_data[15:0]), //i
    .i_port_vdata_valid (i_port_vdata_valid     ), //i
    .i_port_ready       (wctrl_i_port_ready     ), //o
    .o_mem_addr         (wctrl_o_mem_addr[4:0]  ), //o
    .o_mem_data         (wctrl_o_mem_data[15:0] ), //o
    .o_mem_en           (wctrl_o_mem_en         ), //o
    .i_addr             (rctrl_o_addr[5:0]      ), //i
    .o_addr             (wctrl_o_addr[5:0]      ), //o
    .clk                (clk                    ), //i
    .reset              (reset                  )  //i
  );
  RdCntr rctrl (
    .o_port_vdata_data  (rctrl_o_port_vdata_data[15:0]), //o
    .o_port_vdata_valid (rctrl_o_port_vdata_valid     ), //o
    .o_port_ready       (o_port_ready                 ), //i
    .o_mem_addr         (rctrl_o_mem_addr[4:0]        ), //o
    .o_mem_data         (rctrl_o_mem_data[15:0]       ), //i
    .o_mem_en           (rctrl_o_mem_en               ), //o
    .i_addr             (wctrl_o_addr[5:0]            ), //i
    .o_addr             (rctrl_o_addr[5:0]            ), //o
    .clk                (clk                          ), //i
    .reset              (reset                        )  //i
  );
  assign i_port_ready = wctrl_i_port_ready;
  assign o_port_vdata_data = rctrl_o_port_vdata_data;
  assign o_port_vdata_valid = rctrl_o_port_vdata_valid;
  assign rctrl_o_mem_data = mem_spinal_port1;

endmodule

module RdCntr (
  output wire [15:0]   o_port_vdata_data,
  output wire          o_port_vdata_valid,
  input  wire          o_port_ready,
  output wire [4:0]    o_mem_addr,
  input  wire [15:0]   o_mem_data,
  output wire          o_mem_en,
  input  wire [5:0]    i_addr,
  output wire [5:0]    o_addr,
  input  wire          clk,
  input  wire          reset
);

  reg        [5:0]    addr;
  wire       [15:0]   buf0_data;
  wire                buf0_valid;
  reg                 o_mem_en_regNext;
  reg        [15:0]   buf1_data;
  reg                 buf1_valid;
  reg        [15:0]   buf2_data;
  reg                 buf2_valid;
  wire                when_FIFO_l75;
  wire                when_FIFO_l81;

  assign buf0_data = o_mem_data;
  assign buf0_valid = o_mem_en_regNext;
  assign when_FIFO_l75 = (buf0_valid || (! buf2_valid));
  assign when_FIFO_l81 = (! buf2_valid);
  assign o_mem_addr = addr[4:0];
  assign o_mem_en = ((addr != i_addr) && ((o_port_ready || (((buf0_valid || buf1_valid) || buf2_valid) == 1'b0)) || ((((buf0_valid ^ buf1_valid) ^ buf1_valid) == 1'b1) && (((buf0_valid && buf1_valid) && buf1_valid) == 1'b0))));
  assign o_port_vdata_data = (buf2_valid ? buf2_data : buf1_data);
  assign o_port_vdata_valid = (buf2_valid ? buf2_valid : buf1_valid);
  assign o_addr = addr;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      addr <= 6'h0;
      o_mem_en_regNext <= 1'b0;
      buf1_valid <= 1'b0;
      buf2_data <= 16'bxxxxxxxxxxxxxxxx;
      buf2_valid <= 1'b0;
    end else begin
      if(o_mem_en) begin
        addr <= (addr + 6'h01);
      end
      o_mem_en_regNext <= o_mem_en;
      if(when_FIFO_l75) begin
        buf1_valid <= buf0_valid;
      end
      if(o_port_ready) begin
        buf2_valid <= 1'b0;
      end else begin
        if(when_FIFO_l81) begin
          buf2_data <= buf1_data;
          buf2_valid <= buf1_valid;
        end
      end
    end
  end

  always @(posedge clk) begin
    if(when_FIFO_l75) begin
      buf1_data <= buf0_data;
    end
  end


endmodule

module WrCntr (
  input  wire [15:0]   i_port_vdata_data,
  input  wire          i_port_vdata_valid,
  output wire          i_port_ready,
  output wire [4:0]    o_mem_addr,
  output wire [15:0]   o_mem_data,
  output wire          o_mem_en,
  input  wire [5:0]    i_addr,
  output wire [5:0]    o_addr,
  input  wire          clk,
  input  wire          reset
);

  wire       [5:0]    _zz_i_port_ready;
  reg        [5:0]    addr;

  assign _zz_i_port_ready = (i_addr + 6'h20);
  assign i_port_ready = (addr != _zz_i_port_ready);
  assign o_mem_addr = addr[4:0];
  assign o_mem_data = i_port_vdata_data;
  assign o_mem_en = (i_port_ready && i_port_vdata_valid);
  assign o_addr = addr;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      addr <= 6'h0;
    end else begin
      if(o_mem_en) begin
        addr <= (addr + 6'h01);
      end
    end
  end


endmodule
