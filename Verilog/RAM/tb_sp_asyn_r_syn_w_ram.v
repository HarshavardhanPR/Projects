module tb_sp_asyn_r_syn_w_ram;

parameter data_width = 8;
parameter address_width = 8;
parameter depth = 1 << address_width;

reg clk=0;
reg cs;
reg we;
reg oe;
reg [address_width-1:0] address;
wire [data_width-1:0] data;
  
string status;
  string write_status = "write";
  string read_status = "read";
  string no_op_status = "No operation is performed";

  sp_asyn_r_syn_w_ram #(.data_width(data_width), .address_width(address_width),.depth(depth)) dut (.clk(clk),.cs(cs),.we(we),.oe(oe),.address(address),.data(data));

always #5 clk = ~clk;

reg [data_width-1:0] data_reg;


  assign data = (cs && we) ? data_reg : {data_width{1'bz}};
  assign status = ((!oe) ? ((we) ? write_status : no_op_status) : ((we)?no_op_status : read_status));

initial begin

  $monitor($time," clk = %0b : cs = %0b : we = %0b : oe = %0b : address = %0h : data = %0h : status = %0s", clk, cs, we, oe, address, data,status);

cs = 0;
we = 0;
oe = 0;
address = 0;
data_reg = 0;

repeat(2)@(posedge clk) begin

  read_data(8'h01); #1;
  write_data(8'h01,8'hAA); #1;
  read_data(8'h01); #1;
  write_data(8'h04,8'hCC); #1;
  read_data(8'h04); #1;
  write_data(8'h06,8'hDD); #1;
  read_data(8'h06); #1;
  write_data(8'h08,8'hBB); #1;
  read_data(8'h08); #1;
  write_data(8'h01,8'hAA); #1;
  read_data(8'h01); #1;
  write_data(8'h02,8'hAB); #1; //overwrite the data at address 0x00000001 memory location
  read_data(8'h02); #1;

#20;
  $display("Test Complete");
$finish;

end
end

task write_data(input [address_width-1:0] w_address, input [data_width-1:0] w_data);
begin
  
cs = 1; we = 1; oe = 0;
address = w_address;
data_reg = w_data;
@(posedge clk);
cs = 0; we =0;
end
endtask

task read_data(input [address_width-1:0] r_addr);
begin
cs = 1; we = 0; oe = 1;
address = r_addr;
#1;
cs = 0; oe =0;
end
endtask

endmodule
