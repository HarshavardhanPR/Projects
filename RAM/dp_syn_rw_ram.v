module dp_syn_rw_ram #(parameter data_width = 8, 
                       parameter address_width = 8, 
                       parameter depth = 1 << data_width) 
  
  (input clk, we_0, we_1, cs_0, cs_1, oe_0, oe_1, 
   input [address_width-1:0] address_0,address_1, 
   inout [data_width-1:0] data_0, data_1);

reg [data_width-1:0] data_out_0;
reg [data_width-1:0] data_out_1;
reg [data_width-1:0] mem [0:depth-1];

always@(posedge clk) begin : write_block_0_1
if(we_0 && cs_0 && !oe_0) mem[address_0] <= data_0;
if(we_1 && cs_1 && !oe_1) mem[address_1] <= data_1;
end

assign data_0 = (!we_0 && oe_0 && cs_0) ? data_out_0 : {data_width{1'bz}}; 

always@(posedge clk) begin :read_0_block
if(cs_0 && !we_0 && oe_0) data_out_0 <= mem[address_0];
else data_out_0 <= 0;
end

assign data_1 = (cs_1 && !we_1 && oe_1)? data_out_1 : {data_width{1'bz}};

always@(posedge clk) begin :read_1_block
if(cs_1 && !we_1 && oe_1) data_out_1 <= mem[address_1];
else data_out_1 <=0;
end

endmodule
