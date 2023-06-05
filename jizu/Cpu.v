`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/23 10:13:25
// Design Name: 
// Module Name: Cpu
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


module Cpu_test( 
 );
wire [31:0]IR;
reg [5:0]PC=5'b0;
wire Shift_Carry_Out;
wire [31:0]Shift_Out;
reg clk=0;
reg rst;
wire Write_PC;
wire Write_IR;
wire Write_Reg;
wire LA;
wire LB;
wire LC;
wire LF;
wire S;
reg Safe;
wire rm_imm_s;
wire [2:0]rs_imm_s;
reg [2:0]Shift_OP;
reg [3:0]ALU_OP;
reg [7:0]Shift_num;
reg [31:0]Shift_data;
wire [31:0]R_Data_A;
wire [31:0]R_Data_B;
wire [31:0]R_Data_C;
wire [31:0]W_Data;
reg [31:0]A;
reg [31:0]B;
reg [31:0]C;
wire [31:0]F;
wire [3:0]NZCV;
reg [3:0]R_NZCV=4'b0;
localparam fN=3,fZ=2,fC=1,fV=0;
localparam AND =4'b0000;
localparam EOR =4'b0001;
localparam SUB =4'b0010;
localparam RSD =4'b0011;
localparam ADD =4'b0100;
localparam ADC =4'b0101;
localparam SBC =4'b0110;
localparam RSC =4'b0111;
localparam TST =4'b1000;
localparam TEQ =4'b1001;
localparam CMP =4'b1010;
localparam CMN =4'b1011;
localparam ORR =4'b1100;
localparam MOV =4'b1101;
localparam BIC =4'b1110;
localparam MVN =4'b1111;

wire [31:28]cond;
wire [24:21]OP;
wire [19:16]rn;
wire[15:12]rd;
wire[11:0]imm12;
wire [6:5]type;
wire [11:7]imm5;
wire [3:0]rm;
     dist_mem_gen_0 mem(
 .a(PC),
 .spo(IR)
 );   
     assign NZCV=R_NZCV;
     assign  S=IR[20];
     assign  W_Data=F;
  
       assign cond=IR[31:28];
     assign OP=IR[24:21];
    
     assign rn =IR[19:16];
     assign rd=IR[15:12];
     assign imm12=IR[11:0];
     assign type=IR[6:5];
     assign imm5=IR[11:7];
    assign  rm=IR[3:0];
    
    always@(negedge clk)
     begin
       if(Write_PC)
       PC<=PC+1;
     end
 // È¡Ö¸Áî

always@*
 begin
    case(IR[27:25])
    3'b000:                //DP0»òDP1
    begin
    if(IR[15:12]!=4'b1111)  //rd!=1111
     begin
        case(IR[4])
          0:                  //DP0
             begin               
              Safe<=1;
              Shift_num<=imm5;
              Shift_data<=R_Data_B;
              case(type)
              2'b0:Shift_OP<=3'b000;
              2'b1:Shift_OP<=3'b010;
              2'b10:Shift_OP<=3'b100;
              2'b11:Shift_OP<=3'b110;
              endcase
             end   
          1:
           begin
            if(IR[7]==0)         //DP1
             
                 Safe<=1;
                 Shift_num<=R_Data_B[7:0];
                 Shift_data<=R_Data_B;
                      case(type)
              2'b0:Shift_OP<=3'b001;
              2'b1:Shift_OP<=3'b011;
              2'b10:Shift_OP<=3'b101;
              2'b11:Shift_OP<=3'b111;
              endcase
             end  
            endcase  
        end
     end
    3'b001:
      begin
        Safe<=1;              //DP2
                 Shift_num<={4'h0,imm12[11:8]};
                 Shift_data<={24'h0,imm12[7:0]};
                 Shift_OP<=3'b111;
      end
    default:Safe<=0;
   endcase
 end
 always@*
  begin
   case(OP)
   4'b0000,4'b1000:ALU_OP<=4'b0000;
   4'b0001,4'b1001:ALU_OP<=4'b0001;
   4'b0010,4'b1010:ALU_OP<=4'b0010;
   4'b0011,4'b1011:ALU_OP<=4'b0011;
   4'b0100:ALU_OP<=4'b0100;
   4'b0101:ALU_OP<=4'b0101;
   4'b0110:ALU_OP<=4'b0110;
   4'b0111:ALU_OP<=4'b0111;
   4'b1100:ALU_OP<=4'b1100;
   4'b1101:ALU_OP<=4'b1101;
   4'b1110:ALU_OP<=4'b1110;
    4'b1111:ALU_OP<=4'b1111;
    endcase
  end
 always @*
  begin
   if(OP==2'b10&&S)
    Safe<=1;
    else if(rd==4'd15 &&rn==4'd14 && S==1'b1 &&(OP == MOV||OP==SUB))
    Safe<=1;
  end
 state md1(
 .clk(clk),
 .rst(rst),
 .Write_PC(Write_PC),
 .Write_IR(Write_IR),
 .Write_Reg(Write_Reg),
 .LA(LA),
 .LB(LB),
 .LC(LC),
 .LF(LF),
 .S(S),
 .Safe(Safe),
 .rm_imm_s(rm_imm_s),
 .rs_imm_s(rs_imm_s)
 );
GeneralReg mm1( 
.clk(clk),
.R_Addr_A(rn),
.R_Addr_B(rm),
.R_Addr_C(Shift_num),
.W_Addr(rd),
.W_Data(W_Data),
.Mod(0),
.R_Data_A(R_Data_A),
.R_Data_B(R_Data_B),
.R_Data_C(R_Data_C),
.Write_Reg(Write_Reg)
);
always@*
 begin
       if(LA)
       A<=R_Data_A;
        if(LB)
       B<=R_Data_B;
        if(LC)
       C<=R_Data_C;
       
 end

 BarrelShifter mm2(
 .Shift_Data(Shift_data),
 .Shift_Num(Shift_num),
 .Shift_Op(Shift_OP),
 .W_Shift_Out(Shift_Out),
 .W_Shift_Carry_Out(Shift_Carry_Out),
.CF(NZCV[fC])
 );
 ALU mm3(
 .A(A),
 .B(Shift_Out),
 .ALU_op(ALU_OP),
 .W_F(F),
 .Shift_Carry_Out(Shift_Carry_Out),
 .CF(NZCV[fC]),
 .VF(NZCV[fV]),
 .W_NZCV(NZCV));

  always #1 clk = ~clk; // 1ns == 1000ps
 initial begin

  rst=1;
  #1;
  rst=0;
 end
endmodule
