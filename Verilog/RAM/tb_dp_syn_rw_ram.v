module tb_dp_syn_rw_ram;

parameter data_width = 8;
parameter address_width = 8;

reg clk=0;
reg cs_0, we_0, oe_0;
reg cs_1, we_1, oe_1;

reg [address_width-1:0] address_0;
reg [address_width-1:0] address_1;
wire [data_width-1:0] data_0;
wire [data_width-1:0] data_1;

reg [data_width-1:0]  data_0_reg;
reg [data_width-1:0]  data_1_reg;

dp_syn_rw_ram #(data_width, address_width) dut(.clk(clk),.cs_0(cs_0),.we_0(we_0),.oe_0(oe_0),.cs_1(cs_1),.we_1(we_1),.oe_1(oe_1),.address_0(address_0),.address_1(address_1),.data_0(data_0),.data_1
(data_1));

always #5 clk = ~clk;

assign data_0 = (cs_0 && !we_0 && oe_0) ? data_0_reg : {data_width{1'bz}};
assign data_1 = (cs_1 && !we_1 && oe_1) ? data_1_reg : {data_width{1'bz}};

initial begin

  $monitor($time, " | P1: Addr=%h Data=%h | P2: Addr=%h Data=%h", 
             address_0, data_0, address_1, data_1);


{cs_0, we_0, oe_0,cs_1, we_1, oe_1 } = 0;
{data_0_reg, data_1_reg, address_0, address_1} = 0;

repeat(2)@(posedge clk) begin
  if(0) begin // Test 1
  $display("\n--- Reading from Port 1 and Port 2 simultaneously ---");
fork : read_op
read_data_p1(8'h01);
read_data_p2(8'h02);
join
  $display("\n--- Writing FF to Port 1 and 55 to Port 2 simultaneously ---");
fork : write_op
write_data_p1(8'h01,8'hFF);
write_data_p2(8'h02,8'h55);
join
  $display("\n--- Reading from Port 1 and Port 2 simultaneously ---");
fork : read_after_update_op
read_data_p1(8'h01);
read_data_p2(8'h02);
join
  $display("\n--- Writing from Port 1 and Reading from Port 1 simultaneously ---");
fork : read_write_op
begin
write_data_p1(8'h03,8'hAA);
  read_data_p1(8'h03);
end
  $display("\t No operation is performed because, both read and write operations are being called from same port");
  $display("\n--- Writing from Port 1 and Reading from Port 2 simultaneously ---");
begin
write_data_p1(8'h04,8'hDD);
  read_data_p2(8'h02);
end
join
#40;
$display("Test completed");
$finish;
end 
  
  if(1) begin // Test 2
    $display("\n--- Writing FF to P1 and 55 to P2 simultaneously ---");
    fork
      write_data_p1(8'h01, 8'hFF);
      write_data_p2(8'h02, 8'h55);
    join

    $display("\n--- Reading from P1 and P2 simultaneously ---");
    fork
      read_data_p1(8'h01);
      read_data_p2(8'h02);
    join

    $display("\n--- Writing FF to P0 while Reading from P1 ---");
    fork
      write_data_p1(8'h02, 8'hFF);
      read_data_p2(8'h02);
    join

    #20;
    $display("\nTest Complete");
    $finish;
  end
end
end

task write_data_p1(input [address_width-1:0] w_addr_1, input [data_width-1:0] w_data_1);
begin
@(negedge clk);
cs_0 = 1; we_0 = 1; oe_0 = 0;
address_0 = w_addr_1;
data_0_reg = w_data_1;
@(posedge clk);
@(posedge clk);
#1;
cs_0 =0; we_0 =0;
end
endtask

task write_data_p2(input [address_width-1:0] w_addr_2, input [data_width-1:0] w_data_2);
begin
@(negedge clk);
cs_1 = 1; we_1 = 1; oe_1 = 0;
address_1 = w_addr_2;
data_1_reg = w_data_2;
@(posedge clk);
@(posedge clk);
#1;
cs_1 = 0; we_1 = 0;
end
endtask

task read_data_p1(input [address_width-1:0] r_addr_1);
begin
@(negedge clk);
cs_0 = 1; we_0 = 0; oe_0 = 1;
address_0 = r_addr_1;
@(posedge clk);
@(posedge clk);
#1
cs_0 = 0; oe_0 = 0;
end
endtask

task read_data_p2(input [address_width-1:0] r_addr_2);
begin
@(negedge clk);
cs_1 = 1; we_1 = 0; oe_1 = 1;
address_1 = r_addr_2;
@(posedge clk);
@(posedge clk);
#1
cs_1 = 0; oe_1 = 0;
end
endtask


initial begin
$dumpfile("dump.vcd");
$dumpvars(1);
end

endmodule
