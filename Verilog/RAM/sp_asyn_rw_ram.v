module sp_asyn_rw_ram #(parameter address_width = 8, 
                    parameter data_width = 8, 
                    parameter depth = 1 << address_width)

(input clk, cs, we, oe, 
input [address_width-1:0] address,
inout [data_width-1:0] data);

reg [data_width-1:0] data_out;
reg [data_width-1:0] mem [0:depth-1];

assign data = (!we && cs && oe) ? data_out : {data_width{1'bz}};

always@(address or data or cs or we or oe) begin : write_block
if(cs && we && !oe) mem[address] = data;
end

always@(address or cs or we or oe)begin : read_block
if(cs && !we && oe) data_out = mem[address];
end

endmodule
