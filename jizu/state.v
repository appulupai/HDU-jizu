`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/29 21:00:05
// Design Name: 
// Module Name: state
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


module state(clk,rst,Write_PC,Write_IR,Write_Reg,LA,LB,LC,LF,S,Safe,rm_imm_s,rs_imm_s

    );
    input clk;
    input rst;
    input  Safe;
    reg  R_Write_PC;
    reg  R_Write_IR;
   
    reg  R_Write_Reg;
    reg  R_LA;
    reg  R_LB;
    reg  R_LC;
    reg  R_LF;
    output  Write_PC;
    output  Write_IR;
   
    output  Write_Reg;
    output  LA;
    output  LB;
    output  LC;
    output  LF;
    inout  S;
    
    inout  rm_imm_s;
    inout  [2:0]rs_imm_s;
 
    reg [5:0] ST,Next_ST;
    localparam Idle=6'd0;
    localparam S0=6'd1;
    localparam S1=6'd2;
    localparam S2=6'd3;
    localparam S3=6'd4;
    assign  Write_PC=R_Write_PC;
    assign  Write_IR=R_Write_IR;
   
    assign  Write_Reg= R_Write_Reg;
    assign LA=R_LA;
    assign  LB=R_LB;
    assign  LC=R_LC;
    assign LF=R_LF;
    always @(posedge rst or posedge clk)
     begin
      if(rst)
       ST=Idle;
       else
       ST=Next_ST;
     end
    always @*
     begin
      case(ST)
       Idle:Next_ST=S0;
       S0:Next_ST=Safe?S1:S0;
       S1:Next_ST=S2;
       S2:Next_ST=S3;
       S3:Next_ST=S0;
       default:Next_ST=S0;
      endcase
     end 
      always@*
      begin 
          case(Next_ST)
           S0:
             begin
              R_Write_PC=1;
              R_Write_IR=Safe;
              R_Write_Reg=0;
              R_LA=0;
              R_LB=0;
              R_LC=0;
              R_LF=0;
          
             end
           S1:
             begin
              R_Write_PC=0;
              R_Write_Reg=0;
              R_LA=1;
              R_LB=1;
              R_LC=1;
              R_LF=0;
              
             end
           S2:
            begin
              R_Write_PC=0;
              R_Write_Reg=0;
              R_LA=0;
              R_LB=0;
              R_LC=0;
              R_LF=1;
              //S=S;
              //rm_imm_s=rm_imm_s;
              //rs_imm_s=rs_imm_s;
              //Shift_OP=Shift_OP;
              //ALU_OP=ALU_OP;
            end
           S3:
            begin
              R_Write_PC=0;
              R_Write_Reg=1;
              R_LA=0;
              R_LB=0;
              R_LC=0;
              R_LF=0;
            end  
          endcase
      end

endmodule
