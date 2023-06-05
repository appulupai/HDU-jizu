`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/30 12:12:22
// Design Name: 
// Module Name: General_Reg
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


module GeneralReg( clk,R_Addr_A,R_Addr_B,R_Addr_C,W_Addr,W_Data,Mod,R_Data_A,R_Data_B,R_Data_C,Write_Reg);
input [3:0]R_Addr_A;
input [3:0]R_Addr_B;
input [3:0]R_Addr_C;
input [3:0]W_Addr;
input [4:0]Mod;
input [31:0]W_Data;
input clk;
input Write_Reg;
reg  [31:0]GR0_7[7:0];
reg [31:0] GR0_12[12:0];
reg [31:0]SPLR[14:13];
reg [31:0]FIQ[14:8];
reg [31:0]IRQ[14:13];
reg [31:0]ABT[14:13];
reg [31:0]SVC[14:13];
reg [31:0]UND[14:!3];
reg [31:0]MON[14:13];
reg [31:0]HYP;
reg [31:0]PC;
reg [31:0]EMPTY;
reg [31:0]GR[15:0];
output [31:0]R_Data_A;
output [31:0]R_Data_B;
output [31:0]R_Data_C;
integer j ;

always @* case(Mod[3:0])
 0,4'hf:begin
  for (j=0; j<=12;j=j+1) begin
      
        GR[j]<=GR0_12[j];
        end
   for (j=13; j<=14;j=j+1) begin
     
        GR[j]<=SPLR[j];
        end

    GR[15]=PC;

     end
 4'h1:begin
  for (j=0; j<=7;j=j+1) begin
       
        GR[j]<=GR0_7[j];
        end
   for (j=8; j<=14;j=j+1) begin
       
        GR[j]<=FIQ[j];
        end
      
    GR[15]=PC;
     end
 4'h2: begin
    for (j=0; j<=12;j=j+1) begin
     
        GR[j]<=GR0_12[j];
        end
   for (j=13; j<=14;j=j+1) begin
       
        GR[j]<=IRQ[j];
        end
      
    GR[15]=PC;
     end
 4'h3:begin
     for (j=0; j<=12;j=j+1) begin
    
        GR[j]<=GR0_12[j];
        end
   for (j=13; j<=14;j=j+1) begin
    
        GR[j]<=ABT[j];
        end
       
    GR[15]=PC;
     end
 4'h6:begin
     for (j=0; j<=12;j=j+1) begin
   
        GR[j]<=GR0_12[j];
        end
   for (j=13; j<=14;j=j+1) begin
        
        GR[j]<=SVC[j];
        end
        
    GR[15]=PC;
     end
 4'h7:begin
     for (j=0; j<=12;j=j+1) begin
       
        GR[j]<=GR0_12[j];
        end
   for (j=13; j<=14;j=j+1) begin
      
        GR[j]<=UND[j];
        end
        
    GR[15]=PC;
     end
 4'ha:begin
     for (j=0; j<=12;j=j+1) begin
        
        GR[j]<=GR0_12[j];
        end
   for (j=13; j<=14;j=j+1) begin
        MON[j]<=32'h0;
        GR[j]<=MON[j];
        end
        
    GR[15]=PC;
     end
 4'hb:begin
    for (j=0; j<=12;j=j+1) begin
   
        GR[j]<=GR0_12[j];
        end
        
        GR[13]<=HYP[13];
        
    GR[15]=PC;
     end
endcase

assign    R_Data_A=GR[R_Addr_A];
assign    R_Data_B=GR[R_Addr_B];
assign    R_Data_C=GR[R_Addr_C];


always @(posedge clk && Write_Reg)
 begin
      case(Mod[3:0])
 0,4'hf:begin
  if(W_Addr<4'hd)
  GR0_12[W_Addr]<=W_Data;
  else if(W_Addr<4'hf)
  SPLR[W_Addr]<=W_Data;
  else
  PC<=W_Data;
     end
 4'h1:begin
   if(W_Addr<4'h8)
  GR0_7[W_Addr]<=W_Data;
  else if(W_Addr<4'hf)
  FIQ[W_Addr]<=W_Data;
  else
  PC<=W_Data;
     end
 4'h2: begin
    if(W_Addr<4'hd)
  GR0_12[W_Addr]<=W_Data;
  else if(W_Addr<4'hf)
  IRQ[W_Addr]<=W_Data;
  else
  PC<=W_Data;
     end
 4'h3:begin
      if(W_Addr<4'hd)
  GR0_12[W_Addr]<=W_Data;
  else if(W_Addr<4'hf)
  ABT[W_Addr]<=W_Data;
  else
  PC<=W_Data;
     end
 4'h6:begin
      if(W_Addr<4'hd)
  GR0_12[W_Addr]<=W_Data;
  else if(W_Addr<4'hf)
  SVC[W_Addr]<=W_Data;
  else
  PC<=W_Data;
     end
 4'h7:begin
      if(W_Addr<4'hd)
  GR0_12[W_Addr]<=W_Data;
  else if(W_Addr<4'hf)
  UND[W_Addr]<=W_Data;
  else
  PC<=W_Data;
     end
 4'ha:begin
      if(W_Addr<4'hd)
  GR0_12[W_Addr]<=W_Data;
  else if(W_Addr<4'hf)
  MON[W_Addr]<=W_Data;
  else
  PC<=W_Data;
     end
 4'hb:begin
     if(W_Addr<4'hd)
  GR0_12[W_Addr]<=W_Data;
  else if(W_Addr<4'hf)
  HYP<=W_Data;
  else
  PC<=W_Data;
     end
endcase
end
endmodule
