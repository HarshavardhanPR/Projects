module tb_sp_asyn_rw_ram;

parameter data_width = 8;
parameter address_width = 8;

reg clk=0;
reg cs; reg we; reg oe;
reg [address_width-1:0] address;
wire [data_width-1:0] data;

reg [data_width-1:0] data_reg;

string status;
string read_status = "read";
string write_status = "write";
string no_op_status = "no operation is performed";
string overlap = "overlap between read and write operations";

sp_asyn_rw_ram #(data_width, address_width) dut (.clk(clk),.cs(cs),.we(we),.oe(oe),.data(data),.address(address));
  
always #5 clk = ~clk;

assign data = (!we && cs && oe) ? data_reg : {data_width{1'bz}};
assign status = ((oe) ? ((we)? overlap : read_status) : ((we)? write_status : no_op_status));

initial begin
$monitor($time," clk = %0b : cs = %0b : we = %0b : oe = %0b : address = %0h : data = %0h : status = %s", clk ,cs ,we ,oe ,address ,data ,status);
cs = 0; we =0; oe =0; data_reg = 0; address = 0;

repeat(2)@(posedge clk);
begin
read_data(8'h01); #1;
write_data(8'h01, 8'h55); #1;
read_data(8'h01); #1;
write_data(8'h01, 8'hFF); #1;
read_data(8'h01); #1;
read_data(8'h02); #1;
write_data(8'h02, 8'hFF); #1;
read_data(8'h02); #1;
write_data(8'h02, 8'h55);
read_data(8'h02); #1;
write_data(8'h02, 8'h55); #1;
read_data(8'h02); #1;
#20;
$display("Test completed");
$finish;
end

end

task write_data (input [address_width-1:0] addr, input [data_width-1:0] w_data);
cs=1; we=1; oe=0;
address = addr;
data_reg = w_data;
#1;
cs=0; we=0;
endtask

task read_data(input [address_width-1:0] r_addr);
cs=1; we=0; oe=1;
address = r_addr;
#1;
cs=0; oe=0;
endtask

endmodule 
