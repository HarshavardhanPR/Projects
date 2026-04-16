module tb_sp_syn_rw_ram;

parameter data_width = 8;
parameter address_width = 8;

reg clk=0;
reg cs;
reg oe;
reg we;
reg [address_width-1:0] address;
wire [data_width-1:0] data;

reg [data_width-1:0] data_reg;

sp_syn_rw_ram #(data_width, address_width) dut(.clk(clk),.oe(oe),.we(we),.cs(cs),.data(data),.address(address));

assign data = (we && cs) ? data_reg : {data_width{1'bz}};

always #5 clk = ~clk;

initial begin

we = 0;
oe = 0;
cs = 0;
data_reg = 0;
address = 0;

  $monitor($time, " cs = %0b, we = %0b, oe = %0b, data_reg = %0h, address = %0h",cs,we,oe,data_reg,address);

repeat(2) @(posedge clk) begin

write_mem(8'hAA,8'h01);
  write_mem(8'hAB,8'h02);

read_mem(8'h01);
  read_mem(8'h02);

#20;
$finish;
$display("Test Completed");

end
end

task write_mem(input [data_width-1:0] wdata, input [address_width-1:0] addr);
  begin
  @(posedge clk);
cs = 1; we = 1; oe = 0;
address = addr;
data_reg = wdata;
@(posedge clk);
cs=0; we=0;
  end
endtask

task read_mem(input [address_width-1:0] addr);
begin 
@(posedge clk);
cs = 1;oe=1;we=0;
address = addr;
@(posedge clk);
#1;
$display("Read access - at address = %0b : data = %0b",address,data);
cs=0;oe=0;
  end
endtask

endmodule
