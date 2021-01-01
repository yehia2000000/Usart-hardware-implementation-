// 2_bit compartor 
module comparator_2bit (
//io declaration 
input [1:0] a,b,
output out
);
//signal decrltion declare the internal signal 
wire p0,p1,p2,p3;
assign p0 =~a[1]&~a[0]&~b[1]&~b[0];
assign p1 =~a[1]&a[0]&~b[1]&b[0];
assign p2 =a[1]&~a[0]&b[1]&~b[0];
assign p3 =a[1]&a[0]&b[1]&b[0];

assign out = p0|p1|p2|p3;

endmodule
module gates (
input i0 ,i1 ,
output eq 
);
wire i0_n ,i1_n ,p0,p1;

not unit0 (i0_n , i0 );
not unit1 (i1_n  ,i1 );
and unit2 (p0 ,i0_n ,i1_n);
and unit3  (p1 ,i0,i1);
or  unit4 (eq ,p1,p2 ) ;


endmodule 
primitive gate (eq ,a,b );
output eq ;
input a,b ;

table 
0	0:	1;
0	1:	0;
1	0:	0;
1	1:	1;
endtable

endprimitive 

module com_1 (i0,i1,eq);
input i0 ,i1;
output eq ;

wire p0 ,p1 ;

assign p0 = ~i0&~i1;
assign p1 = i0& i1;
assign eq = p1|p0;


endmodule 

module com_2 (a,b,c);
input [1:0] a,b;
output c;

wire p0,p1;

com_1 g1 (a[0],b[0],p0);

com_1 g2 (a[1],b[1],p1);

assign c= p0&p1;


endmodule
module tb_com ;
reg [1:0]a,b;
wire c;

initial 
begin 
$monitor ("%b     %b     %b   ",a,b,c );
a=2'b00;
b=2'b00;

#10
a=2'b00;
b=2'b01;
#10
a=2'b10;
b=2'b00;
#10
a=2'b11;
b=2'b11;

end


com_2 g1(a,b,c);

endmodule

