module LS193 (
input CLR, LOAD_Bar,   // CLR active high (posedge) t_{PHL}, 
						 // LOAD active low (negedge) t_{PLH}, 
						 // CLR clears QA~QD, LOAD presets A~D
input A,B,C,D,	    // D is MSB, A is LSB
input UP,DOWN,     // both on posedge (for count) and negedge (for carry borrow)
output QA,QB,QC,QD,// QD is MSB, QA is LSB
output reg CO_Bar,BO_Bar,       // CO, BO are active low
output reg mode
);

// combine all IO pins

reg [3:0] inputReg;
always@(*)
	begin
	 inputReg[0] = A;
	 inputReg[1] = B;
	 inputReg[2] = C;
	 inputReg[3] = D;
   end

reg [3:0] Qout;
assign QA = Qout[0];
assign QB = Qout[1];
assign QC = Qout[2];
assign QD = Qout[3];

// intitial condition
initial begin
	CO_Bar=1'b1;
	BO_Bar=1'b1;
	mode = 1'b1;
end
// Serial logic
always@(negedge UP or negedge DOWN)
	begin
		if(~UP)
			mode<=1;
		else if(~DOWN)
			mode<=0;
		else
			mode<=mode;
	end

always@(posedge CLR or posedge UP or posedge DOWN or negedge LOAD_Bar or posedge mode)
	begin
		if(CLR)
			Qout<=4'b0;
		else if(~LOAD_Bar)
			Qout<=inputReg;
		else if(mode)
			Qout<=Qout+4'b0001;
		else if(DOWN)
			Qout<=Qout-4'b0001;
		else if(Qout==4'b1111) // overflow
			Qout<=4'b0;
		else if(Qout==4'b0) // underflow
			Qout<=4'b1111;
		else
			Qout<=Qout;
	end
	
always@(negedge UP or negedge QD) // QD for fast(correct) pull up of CO_Bar
	begin
		if(~UP)
			begin
			if(Qout==4'b1111)
				begin
					CO_Bar<=1'b0;
				end
			else
				begin
					CO_Bar<=1'b1;
				end
			end
		else
			begin
				CO_Bar<=1'b1;
			end
	end
always@(negedge DOWN or posedge QD)  // QD for fast(correct) pull up of BO_Bar
	begin
		if(~DOWN)
			begin
			if(Qout==4'b0000)
				begin
					BO_Bar<=1'b0;
				end
			else
				begin
					BO_Bar<=1'b1;
				end
			end
		else
			begin
				BO_Bar<=1'b1;
			end
	end
	
endmodule