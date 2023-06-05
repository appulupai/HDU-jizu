`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/18 11:20:30
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(A,B,ALU_op,W_F,Shift_Carry_Out,CF,VF,W_NZCV);
input [31:0] A;
input [31:0] B;
input [3:0] ALU_op;
input CF;
input VF;
input Shift_Carry_Out;
reg Cout;
reg [31:0] F;
reg [3:0] NZCV=4'h0;
output [31:0] W_F;
output [3:0] W_NZCV;
assign W_F=F;
assign W_NZCV=NZCV;
localparam fN=3,fZ=2,fC=1,fV=0;
always@* 
  begin
	case(ALU_op)
	4'h0:
		begin
		  F=A&B;
		  NZCV[fN]=F[31];
		  NZCV[fZ]=(F==0);
		  NZCV[fC]=Shift_Carry_Out;
		  NZCV[fV]=VF;
		end
	4'h1:
		begin
		F=A^B;
		NZCV[fN]=F[31];
		NZCV[fZ]=(F==0);
		NZCV[fC]=Shift_Carry_Out;
		NZCV[fV]=VF;  
		end
	4'h2:
		begin
		{Cout,F}=A-B;
		NZCV[fN]=F[31];
		NZCV[fZ]=(F==0);
		NZCV[fC]=Cout;
		NZCV[fV]=A[31]^B[31]^F[31]^Cout;
		end
	4'h3:
		begin
		{Cout,F}=B-A;
		NZCV[fN]=F[31];
		NZCV[fZ]=(F==0);
		NZCV[fC]=Cout;
		NZCV[fV]=A[31]^B[31]^F[31]^Cout;
		end
	4'h4:
		begin
		{Cout,F}=B+A;
		NZCV[fN]=F[31];
		NZCV[fZ]=(F==0);
		NZCV[fC]=Cout;
		NZCV[fV]=A[31]^B[31]^F[31]^Cout;
		end
	4'h5:
		begin
		{Cout,F}=B+A+CF;
		NZCV[fN]=F[31];
		NZCV[fZ]=(F==0);
		NZCV[fC]=Cout;
		NZCV[fV]=A[31]^B[31]^F[31]^Cout;
		end
	4'h6:
		begin
		{Cout,F}=A-B+CF-1;
		NZCV[fN]=F[31];
		NZCV[fZ]=(F==0);
		NZCV[fC]=Cout;
		NZCV[fV]=A[31]^B[31]^F[31]^Cout;
		end
	4'h7:
		begin
		{Cout,F}=B-A+CF-1;
		NZCV[fN]=F[31];
		NZCV[fZ]=(F==0);
		NZCV[fC]=Cout;
		NZCV[fV]=A[31]^B[31]^F[31]^Cout;
		end
	4'h8:
		begin
		F=A;
		end
	4'hA:
		begin
		{Cout,F}=A-B+32'h4;
		NZCV[fN]=F[31];
		NZCV[fZ]=(F==0);
		NZCV[fC]=Cout;
		NZCV[fV]=A[31]^B[31]^F[31]^Cout;
		end
	4'hC:
		begin
		F=A^B;
		NZCV[fN]=F[31];
		NZCV[fZ]=(F==0);
		NZCV[fC]=Shift_Carry_Out;
		NZCV[fV]=VF;
		end
	4'hD:
		begin
		F=B;
		end
	4'hE:
		begin
		F=A&(~B);
		NZCV[fN]=F[31];
		NZCV[fZ]=(F==0);
		NZCV[fC]=Shift_Carry_Out;
		NZCV[fV]=VF;  
		end
	4'hF:
		begin
		F=~B;
		NZCV[fN]=F[31];
		NZCV[fZ]=(F==0);
		NZCV[fC]=Shift_Carry_Out;
	    NZCV[fV]=VF;
		end
    endcase
end

endmodule
