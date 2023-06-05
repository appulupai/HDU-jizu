`timescale 1ns / 1ps
// 通过数据输入输出测试开关、LED、数码管；通过数码管使能测试按钮
module BarrelShifter(Shift_Data,Shift_Num,Shift_Op,W_Shift_Out,W_Shift_Carry_Out,CF);
    input [31:0] Shift_Data;
    input [7:0] Shift_Num;
    input [2:0] Shift_Op;
    input CF;
    reg [31:0]Shift_Out;
    reg Shift_Carry_Out;
    output [31:0] W_Shift_Out;
    output  W_Shift_Carry_Out;
    assign W_Shift_Out=Shift_Out;
    assign W_Shift_Carry_Out=Shift_Carry_Out;
    
     always @* case (Shift_Op[2:1])
     0:  //逻辑左移
     begin
      if(Shift_Num==8'b00000000) 
        Shift_Out = Shift_Data[31:0];  //不移位
      else if(Shift_Num<=8'b00100000)
       begin
        Shift_Out = Shift_Data[31:0] << Shift_Num[7:0];
        Shift_Carry_Out =Shift_Data[6'b10000-Shift_Num[7:0]];
       end
      else
       begin
        Shift_Out = 1'b0;
        Shift_Carry_Out = 1'b0;
       end
     end
     1:   //逻辑右移
     begin
      if(Shift_Num==1'b0)
       begin
        if(Shift_Op[0]==0)
         begin
          Shift_Out = 1'b0;
          Shift_Carry_Out =Shift_Data[31];
        end
        else
           Shift_Out = 1'b0;
        end
      else 
 
            begin
              if(Shift_Num<=6'b100000)
              begin
             Shift_Out = Shift_Data[31:0] >> Shift_Num[7:0];
             Shift_Carry_Out = 1'b0;
              end
              else
              begin
              Shift_Out = 1'b0;
             Shift_Carry_Out = Shift_Data[31];
             end
            end
     end
     2:   //算数右移
     begin
     if(Shift_Num==1'b0)
      begin
       if(Shift_Op[0]==0)
        begin
         Shift_Out = {32{Shift_Data[31]}};
         Shift_Carry_Out =Shift_Data[31];
         end
       else
          Shift_Out = Shift_Data;
       end
      else 
            begin
              if(Shift_Num<=6'b100000)
                 begin
                  Shift_Out = {{32{Shift_Data[31]}},Shift_Data} >> Shift_Num;
                  Shift_Carry_Out = Shift_Data[Shift_Num-1'b1];
                  end
              else
                 begin
                   Shift_Out = {32{Shift_Data[31]}};
                   Shift_Carry_Out = Shift_Data[31];
                  end
            end
     end                                   
     3:   //(带扩展)循环右移
     begin
      if(Shift_Num==1'b0)
      begin
       if(Shift_Op[0]==0)
        begin
         Shift_Out = {CF,Shift_Data[31:1]}; //CF是进位借位标志
         Shift_Carry_Out =Shift_Data[0];
        end
        else
          Shift_Out = Shift_Data;       //不移位
       end
      else 
            begin
              if(Shift_Num<=6'b100000)
               begin
             Shift_Out = {Shift_Data,Shift_Data} >> Shift_Num;
             Shift_Carry_Out = Shift_Data[Shift_Num-1'b1];
               end
              else
              begin
              Shift_Out = {Shift_Data,Shift_Data}>>Shift_Num[4:0];
             Shift_Carry_Out = Shift_Data[Shift_Data[4:0]-1];
              end
            end
     end                                     

     endcase
 
endmodule // BarrelShifter