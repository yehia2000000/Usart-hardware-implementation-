`timescale 1ns/100ps 
module parity_gen1 (rst, data_in, parity_type, parity_out);
//decleration of the ports 
input [7:0] data_in ;
input [1:0] parity_type ;
input rst;
output reg  parity_out;
reg[7:0] data; 
always @(data_in)
begin 
if (rst)
begin
case (parity_type)
2'b00:begin  parity_out <= 1'bx;    end  //no parity 
2'b01:begin data <= data_in[7]+data_in[6]+ data_in[5]+data_in[4]+ data_in[3]+data_in[2]+ data_in[1]+ data_in[0];end// odd parity
2'b10:begin data <=~data; data <= data_in[7]+data_in[6]+ data_in[5]+data_in[4]+ data_in[3]+data_in[2]+ data_in[1]+ data_in[0]+1'b1;end// even parity
2'b11:begin data <=~data; data <= data_in[7]+data_in[6]+ data_in[5]+data_in[4]+ data_in[3]+data_in[2]+ data_in[1]+ data_in[0]+1'b1; end // no parity at same frame (odd parity)
endcase 
end
else begin data<=0;  end 
end
always@(data)
begin 
if (data%2==0)begin  parity_out <=0 ;  end
else begin parity_out<=1; end

end

endmodule 


module frame_gen1(rst, data_in, parity_out, parity_type, stop_bits, data_length, frame_out);

input rst,parity_out ,stop_bits,data_length;
input [7:0] data_in;
input [1:0] parity_type;
output reg [11:0] frame_out;

always @(data_in)
begin
case(parity_type)
2'b00:begin  
if (stop_bits)
begin 
if (data_length)
begin 
frame_out <={1'b1,1'b1,1'bz,data_in[7] ,data_in[6],data_in[5],data_in[4],data_in[3],data_in[2],data_in[1],data_in[0],1'b0};
end
else
begin
frame_out <={1'b1,1'b1,1'bz,1'bz,data_in[6],data_in[5],data_in[4],data_in[3],data_in[2],data_in[1],data_in[0],1'b0};
end
end
else
begin
if (data_length)
begin 
frame_out <={1'bz,1'b1,1'bz,data_in[7] ,data_in[6],data_in[5],data_in[4],data_in[3],data_in[2],data_in[1],data_in[0],1'b0};
end
else
begin
frame_out <={1'bz,1'b1,1'bz,1'bz,data_in[6],data_in[5],data_in[4],data_in[3],data_in[2],data_in[1],data_in[0],1'b0};
end
end
end
2'b01:begin  
if (stop_bits)
begin 
if (data_length)
begin 
frame_out <={1'b1,1'b1,parity_out,data_in[7] ,data_in[6],data_in[5],data_in[4],data_in[3],data_in[2],data_in[1],data_in[0],1'b0};
end
else
begin
frame_out <={1'b1,1'b1,parity_out,1'bz,data_in[6],data_in[5],data_in[4],data_in[3],data_in[2],data_in[1],data_in[0],1'b0};
end
end
else
begin
if (data_length)
begin 
frame_out <={1'bz,1'b1,parity_out,data_in[7] ,data_in[6],data_in[5],data_in[4],data_in[3],data_in[2],data_in[1],data_in[0],1'b0};
end
else
begin
frame_out <={1'bz,1'b1,parity_out,1'bz,data_in[6],data_in[5],data_in[4],data_in[3],data_in[2],data_in[1],data_in[0],1'b0};
end
end
end

2'b10:begin  
if (stop_bits)
begin 
if (data_length)
begin 
frame_out <={1'b1,1'b1,parity_out,data_in[7] ,data_in[6],data_in[5],data_in[4],data_in[3],data_in[2],data_in[1],data_in[0],1'b0};
end
else
begin
frame_out <={1'b1,1'b1,parity_out,1'bz,data_in[6],data_in[5],data_in[4],data_in[3],data_in[2],data_in[1],data_in[0],1'b0};
end
end
else
begin
if (data_length)
begin 
frame_out <={1'bz,1'b1,parity_out,data_in[7] ,data_in[6],data_in[5],data_in[4],data_in[3],data_in[2],data_in[1],data_in[0],1'b0};
end
else
begin
frame_out <={1'bz,1'b1,parity_out,1'bz,data_in[6],data_in[5],data_in[4],data_in[3],data_in[2],data_in[1],data_in[0],1'b0};
end
end
end

2'b11:begin  
if (stop_bits)
begin 
if (data_length)
begin 
frame_out <={1'b1,1'b1,1'bz,data_in[7] ,data_in[6],data_in[5],data_in[4],data_in[3],data_in[2],data_in[1],data_in[0],1'b0};
end
else
begin
frame_out <={1'b1,1'b1,1'bz,1'bz,data_in[6],data_in[5],data_in[4],data_in[3],data_in[2],data_in[1],data_in[0],1'b0};
end
end
else
begin
if (data_length)
begin 
frame_out <={1'bz,1'b1,1'bz,data_in[7] ,data_in[6],data_in[5],data_in[4],data_in[3],data_in[2],data_in[1],data_in[0],1'b0};
end
else
begin
frame_out <={1'bz,1'b1,1'bz,1'bz,data_in[6],data_in[5],data_in[4],data_in[3],data_in[2],data_in[1],data_in[0],1'b0};
end
end
end



endcase
end
always @(rst)
begin 
if (rst)begin frame_out <= frame_out;  end

else begin frame_out <= 0;   end 

end

endmodule 
//testbench
module tb_parity ();
reg [7:0] data_in ;
reg [1:0] parity_type ;
reg rst;
wire  parity_out;

initial 
begin 
$monitor ("%b   %b",rst , parity_out);
rst=0;
#5
rst=1;
parity_type = 2'b11; 

data_in = 8'b1111_0000;

end


parity_gen1 g1 (rst, data_in, parity_type, parity_out);
endmodule 


module tb_frame ();

reg rst,parity_out ,stop_bits,data_length;
reg [7:0] data_in;
reg [1:0] parity_type;
wire [11:0] frame_out;

initial 
begin 
$monitor ("%b   %b    %b   %b   %b   %b",rst,parity_type ,stop_bits,data_length,parity_out,frame_out);
rst=0;
#5
rst=1;
parity_type = 2'b01;
stop_bits=1;
data_length=0;
parity_out=1;
#5
data_in=8'b1101_1001;

end 
frame_gen1 g1(rst, data_in, parity_out, parity_type, stop_bits, data_length, frame_out);

endmodule 
module baud_gen1(rst, clock, baud_rate, baud_out);

input rst , clock ;
input [1:0] baud_rate;
output reg baud_out;
reg[15:0] baud;
always @(posedge clock)
begin 
case (baud_rate)
00:
begin
if (baud==10416)
begin 
baud_out <= ~(baud_out); baud<=0;
end 
else 
begin 
baud<=baud+1;
end
end
01:
begin
if (baud==5208)
begin 
baud_out <= ~(baud_out); baud<=0;
end 
else 
begin 
baud<=baud+1;
end                        
end
10:
begin
if (baud== 2604 )
begin 
baud_out <= ~(baud_out); baud<=0;
end 
else 
begin 
baud<=baud+1;
end                             
end
11:
begin
if (baud== 1302 )
begin 
baud_out <= ~(baud_out); baud<=0;
end 
else 
begin 
baud<=baud+1;
end                            
end

endcase


end

always @(rst)
begin 
if (!rst)begin baud <=0; baud_out<=0;    end
end

endmodule
module tb_baud_gen1();
reg rst , clock ;
reg [1:0] baud_rate;
wire baud_out;
initial 
begin 
$monitor ("%b  %b  %b",rst,clock,baud_out);

baud_rate =2'b11;
rst=0;
#3
rst=1;

clock=0;

baud_rate =2'b01;

end
always
begin 
#10
clock=~clock;
end


baud_gen1 g1(rst, clock, baud_rate, baud_out);
endmodule 


module shift_reg1(rst, frame_out, parity_type, stop_bits, data_length, send, baud_out, data_out, p_parity_out, tx_active, tx_done);
input rst , stop_bits , data_length ,send ,baud_out;
input [11:0] frame_out;
input [1:0] parity_type;
output reg  data_out;
output reg p_parity_out,tx_active,tx_done;
reg [7:0]p;

always @(posedge baud_out)
begin
case (parity_type)
00:
begin 
if (send)
begin
if (stop_bits)
begin 
if (data_length)
begin
data_out<=p[0]; 
p <= {1'b0,p[7],p[6],p[5],p[4],p[3],p[2],p[1]};
p_parity_out<=frame_out[9];
end
else
begin
data_out<=p[0]; 
p <= {1'b0,p[7],p[6],p[5],p[4],p[3],p[2],p[1]};
p_parity_out<=frame_out[9];
end
end
else
begin
if (data_length)
begin 
data_out<=p[0]; 
p <= {1'b0,p[7],p[6],p[5],p[4],p[3],p[2],p[1]};
p_parity_out<=frame_out[9];end
else
begin
data_out<=p[0]; 
p <= {1'b0,1'bz,p[6],p[5],p[4],p[3],p[2],p[1]};
p_parity_out<=frame_out[9];
end
end
end
end
01:
begin
if (send)
begin
if (stop_bits)
begin 
if (data_length)
begin
data_out<=p[0]; 
p <= {1'b0,p[7],p[6],p[5],p[4],p[3],p[2],p[1]};
p_parity_out<=frame_out[9];
end
else
begin
data_out<=p[0]; 
p <= {1'b0,1'bz,p[6],p[5],p[4],p[3],p[2],p[1]};
p_parity_out<=frame_out[9];
end
end
else
begin
if (data_length)
begin 
data_out<=p[0]; 
p <= {1'b0,p[7],p[6],p[5],p[4],p[3],p[2],p[1]};
p_parity_out<=frame_out[9];end
else
begin
data_out<=p[0]; 
p <= {1'b0,1'bz,p[6],p[5],p[4],p[3],p[2],p[1]};
p_parity_out<=frame_out[9];
end
end
end
end
10:
begin
if (send)
begin
if (stop_bits)
begin 
if (data_length)
begin
data_out<=p[0]; 
p <= {1'b0,p[7],p[6],p[5],p[4],p[3],p[2],p[1]};
p_parity_out<=frame_out[9];
end
else
begin
data_out<=p[0]; 
p <= {1'b0,1'bz,p[6],p[5],p[4],p[3],p[2],p[1]};
p_parity_out<=frame_out[9];
end
end
else
begin
if (data_length)
begin 
data_out<=p[0]; 
p <= {1'b0,p[7],p[6],p[5],p[4],p[3],p[2],p[1]};
p_parity_out<=frame_out[9];end
else
begin
data_out<=p[0]; 
p <= {1'b0,1'bz,p[6],p[5],p[4],p[3],p[2],p[1]};
p_parity_out<=frame_out[9];
end
end
end
end
11:
begin
if (send)
begin
if (stop_bits)
begin 
if (data_length)
begin
data_out<=p[0]; 
p <= {1'b0,p[7],p[6],p[5],p[4],p[3],p[2],p[1]};
p_parity_out<=frame_out[9];
end
else
begin
data_out<=p[0]; 
p <= {1'b0,1'bz,p[6],p[5],p[4],p[3],p[2],p[1]};
p_parity_out<=frame_out[9];
end
end
else
begin
if (data_length)
begin 
data_out<=p[0]; 
p <= {1'b0,p[7],p[6],p[5],p[4],p[3],p[2],p[1]};
p_parity_out<=frame_out[9];end
else
begin
data_out<=p[0]; 
p <= {1'b0,1'bz,p[6],p[5],p[4],p[3],p[2],p[1]};
p_parity_out<=frame_out[9];
end
end
end
end
endcase
if (p=={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0})
begin 
tx_done<=1;tx_active<=0;
end
else
begin 
tx_active<=1;tx_done<=0;
end
end

always @(rst)
begin 
if (!rst)begin data_out <=0; p_parity_out<=0;tx_active<=0; tx_done<=0;   end
else begin p <= {frame_out[8],frame_out[7],frame_out[6],frame_out[5],frame_out[4],frame_out[3],frame_out[2],frame_out[1]};   end 
end

endmodule 
module tb_shift_reg1();
reg rst , stop_bits , data_length ,send ,baud_out;
reg [11:0] frame_out;
reg [1:0] parity_type;
wire data_out;
wire p_parity_out,tx_active,tx_done;

initial
begin 
$monitor ("%b  %b  %b   %b %b  %b  %b       %b   %b   %b   %b",rst,stop_bits,data_length,send,baud_out,parity_type,frame_out,data_out,p_parity_out,tx_active,tx_done);
rst=0;
#6
rst=1;
baud_out=0;
frame_out =12'bz1z1_1011_1010;
parity_type=2'b00;
send=1;
stop_bits=1;
data_length=1;

end

always
begin
#5
baud_out=~baud_out;
end


shift_reg1 g1(rst, frame_out, parity_type, stop_bits, data_length, send, baud_out, data_out, p_parity_out, tx_active, tx_done);

endmodule 

module uart_tx(clock,rst,send,baud_rate,data_in,parity_type,stop_bits,data_length,data_out,p_parity_out,tx_active,tx_done);
input clock, rst, send;
input [1:0]baud_rate;
input [7:0] data_in;
input [1:0] parity_type; 	//refer to the block comment above. 
input 	stop_bits; 		//low when using 1 stop bit, high when using two stop bits
input 	data_length; 	//low when using 7 data bits, high when using 8.
	
output  data_out; 		//Serial data_out
output  p_parity_out;	//parallel odd parity output, low when using the frame parity.
output  tx_active; 		//high when Tx is transmitting, low when idle.
output  tx_done ;	//high when transmission is done, low when not.

wire parity_out, baud_out;
wire [10:0] frame_out;
parity_gen1 g1(rst, data_in, parity_type, parity_out);
frame_gen1  g2(rst, data_in, parity_out, parity_type, stop_bits, data_length, frame_out);

baud_gen1   g5(rst, clock, baud_rate, baud_out);
shift_reg1  g3(rst, frame_out, parity_type, stop_bits, data_length, send, baud_out, data_out, p_parity_out, tx_active, tx_done);

endmodule 
module tb_uart ();

reg clock, rst, send;
reg [1:0]baud_rate;
reg [7:0] data_in;
reg [1:0] parity_type; 	 
reg 	stop_bits; 		
reg 	data_length; 	
	
wire data_out; 		
wire p_parity_out;	
wire tx_active; 		
wire tx_done ;

initial 
begin
$monitor ("%b %b %b %b",data_out,p_parity_out,clock,data_in);
clock=0;
rst=0;
#11
rst=1;
baud_rate=2'b10;
data_in=8'b1001_1001;
send=1;
parity_type=2'b01;
stop_bits=1;
data_length=1;

end

always
begin
#10
clock=~clock;
end

uart_tx g1(clock,rst,send,baud_rate,data_in,parity_type,stop_bits,data_length,data_out,p_parity_out,tx_active,tx_done);


endmodule 