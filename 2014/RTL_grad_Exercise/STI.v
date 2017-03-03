module STI(
		clk, reset,
		pi_data,
		load, pi_end,
		pi_length,
		pi_low, pi_msb, pi_fill,
		so_data, so_valid
	);

//io
	//input
input clk, reset;
input [15:0] pi_data;
input load, pi_end;
input [1:0] pi_length;
input pi_low, pi_msb, pi_fill;
	//output
output reg so_data, so_valid;
	//reg
reg [15:0] pi_data_r;
reg load_r, pi_end_r;
reg [1:0] pi_length_r;
reg pi_low_r, pi_msb_r, pi_fill_r;
reg so_data_next, so_valid_next;

//reg
reg store_next [0:31], store [0:31];
reg state_next, state;
reg [4:0] counter_end_next, counter_end;

//parameter
parameter IDLE = 1'b0, OUT = 1'b1;
integer i;

//combinational
always@(*) begin
	case(state)
		IDLE: begin
			if(load_r) begin
				if(pi_length_r == 2'd3) begin
					if(pi_fill_r == 1'b1) begin
						if(pi_msb_r == 1'b1) begin
							for(i = 31; i >= 16; i = i - 1) begin
								store_next[i] = pi_data_r[i - 16];
							end
							for(i = 15; i > 0; i = i - 1) begin
								store_next[i] = store[i - 1];
							end
							store_next[0] = 1'b0;
						end	
						else begin
							for(i = 31; i > 15; i = i - 1) begin
								store_next[i] = store[i - 1];
							end
							for(i = 15; i >= 0; i = i - 1) begin
								store_next[i] = pi_data_r[15 - i];
							end
						end			
					end
					else begin
						if(pi_msb_r == 1'b1) begin
							for(i = 31; i >= 16; i = i - 1) begin
								store_next[i] = store[i - 1];
							end
							for(i = 15; i >= 0; i = i - 1) begin
								store_next[i] = pi_data_r[i];
							end
						end
						else begin
							for(i = 31; i >= 16; i = i - 1) begin
								store_next[i] = pi_data_r[31 - i];
							end
							for(i = 15; i > 0; i = i - 1) begin
								store_next[i] = store[i - 1];
							end
							store_next[0] = 1'b0;
						end
					end
					counter_end_next = 5'd31;
				end
				else if(pi_length_r == 2'd2) begin
					if(pi_fill_r == 1'b1) begin
						if(pi_msb_r == 1'b1) begin
							for(i = 31; i >= 16; i = i - 1) begin
								store_next[i] = pi_data_r[i - 16];
							end
							for(i = 15; i > 0; i = i - 1) begin
								store_next[i] = store[i - 1];
							end
							store_next[0] = 1'b0;
						end
						else begin
							for(i = 31; i > 23; i = i - 1) begin
								store_next[i] = store[i - 1];
							end
							for(i = 23; i >= 8; i = i - 1) begin
								store_next[i] = pi_data_r[23 - i];
							end
							for(i = 7; i > 0; i = i - 1) begin
								store_next[i] = store[i - 1];
							end
							store_next[i] = 1'b0;
						end			
					end
					else begin
						if(pi_msb_r == 1'b1) begin
							for(i = 31; i > 23; i = i - 1) begin
								store_next[i] = store[i - 1];
							end
							for(i = 23; i >= 8; i = i - 1) begin
								store_next[i] = pi_data_r[i - 8];
							end
							for(i = 7; i > 0; i = i - 1) begin
								store_next[i] = store[i - 1];
							end
							store_next[0] = 1'b0;
						end
						else begin
							for(i = 31; i >= 16; i = i - 1) begin
								store_next[i] = pi_data_r[31 - i];
							end
							for(i = 15; i > 0; i = i - 1) begin
								store_next[i] = store[i - 1];
							end
							store_next[0] = 1'b0;
						end
					end
					counter_end_next = 5'd23;
				end
				else if(pi_length == 2'd1) begin
					if(pi_msb_r == 1'b1) begin
						for(i = 31; i >= 16; i = i - 1) begin
							store_next[i] = pi_data_r[i - 16];
						end
						for(i = 15; i > 0; i = i - 1) begin
							store_next[i] = store[i - 1];
						end
						store_next[0] = 1'b0;
					end
					else begin
						for(i = 31; i >= 16; i = i - 1) begin
							store_next[i] = pi_data_r[31 - i];
						end
						for(i = 15; i > 0; i = i - 1) begin
							store_next[i] = store[i - 1];
						end
						store_next[0] = 1'b0;
					end
					counter_end_next = 5'd15;
				end
				else begin 
					if(pi_low_r == 1'b1) begin
						if(pi_msb_r == 1'b1) begin
							for(i = 31; i >= 24; i = i - 1) begin
								store_next[i] = pi_data_r[i - 16];
							end
							for(i = 23; i > 0; i = i - 1) begin
								store_next[i] = store[i - 1];
							end
							store_next[0] = 1'b0;
						end
						else begin
							for(i = 24; i < 32; i = i + 1) begin
								store_next[i] = pi_data_r[39 - i];
							end
							for(i = 1; i < 24; i = i + 1) begin
								store_next[i] = store[i - 1];
							end
							store_next[0] = 1'b0;
						end
					end
					else begin
						if(pi_msb_r == 1'b1) begin
							for(i = 31; i >= 24; i = i - 1) begin
								store_next[i] = pi_data_r[i - 24];
							end
							for(i = 23; i > 0; i = i - 1) begin
								store_next[i] = store[i - 1];
							end
							store_next[0] = 1'b0;
						end
						else begin
							for(i = 24; i < 32; i = i + 1) begin
								store_next[i] = pi_data_r[31 - i];
							end
							for(i = 1; i < 24; i = i + 1) begin
								store_next[i] = store[i - 1];
							end
							store_next[0] = 1'b0;
						end
					end
					counter_end_next = 5'd7;
				end
				state_next = OUT;
				so_valid_next = 1'b1;
			end
			else begin
				for(i = 31; i > 0; i = i - 1) begin
					store_next[i] = store[i - 1];
				end
				store_next[0] = 1'b0;
				state_next = state;
				counter_end_next = counter_end;
				so_valid_next = so_valid;
			end
			so_data_next = store_next[31];
		end
		OUT: begin
			for(i = 31; i > 0; i = i - 1) begin
				store_next[i] = store[i - 1];
			end
			store_next[0] = 1'b0;
			if(counter_end == 5'd0) begin
				state_next = IDLE;
				counter_end_next = counter_end;
				so_valid_next = 1'b0;
			end
			else begin
				state_next = state;
				counter_end_next = counter_end - 5'd1;
				so_valid_next = so_valid;
			end
			so_data_next = store_next[31];
		end
	endcase
end

//sequential
always@(posedge clk or posedge reset) begin
	if(reset) begin
		pi_data_r <= 16'd0;
		load_r <= 1'b0; pi_end_r <= 1'b0;
		pi_length_r <= 2'd0;
		pi_low_r <= 1'b0; pi_msb_r <= 1'b0; pi_fill_r <= 1'b0;
		for(i = 31; i >= 0; i = i - 1) begin
			store[i] <= 1'b0;
		end
		state <= 1'b0;
		counter_end <= 5'd0;
		so_data <= 1'b0;
		so_valid <= 1'b0;
	end
	else begin
		pi_data_r <= pi_data;
		load_r <= load; pi_end_r <= pi_end;
		pi_length_r <= pi_length;
		pi_low_r <= pi_low; pi_msb_r <= pi_msb; pi_fill_r <= pi_fill;
		for(i = 31; i >= 0; i = i - 1) begin
			store[i] <= store_next[i];
		end
		state <= state_next;
		counter_end <= counter_end_next;
		so_data <= so_data_next;
		so_valid <= so_valid_next;
	end
end

endmodule
