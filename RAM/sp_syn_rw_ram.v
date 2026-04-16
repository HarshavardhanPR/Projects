module sp_syn_rw_ram 
  #(parameter data_width = 8, 
    parameter address_width = 8, 
    parameter depth = 1 << address_width) 
  
  (input clk,input cs, input oe, we, input [address_width-1:0] address, inout [data_width-1:0] data);
  
  reg [data_width-1:0] data_out;
  reg [data_width-1:0] mem [0:depth-1];
  reg oe_r;
  
  assign data = (oe_r) ? data_out : 8'bz;
  
  always @(posedge clk) begin : memory_write
    if(cs && we) begin mem [address] = data; end
  end
  
  always@(posedge clk) begin : memory_read
    if(oe && cs && !we) begin data_out = mem [address]; oe_r = 1; end
    else oe_r = 0;
  end
  
endmodule
