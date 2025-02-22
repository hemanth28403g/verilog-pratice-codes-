module FIFO #(parameter DATA_WIDTH = 8,
              parameter FIFO_DEPTH = 32)
             (output reg [DATA_WIDTH - 1:0] Data_out,
              output reg Full,
              output reg Empty,
              input [DATA_WIDTH - 1:0] Data_In,
              input wr_en,
              input rd_en,
              input clk,
              input reset);
             
reg [DATA_WIDTH - 1:0] memory [FIFO_DEPTH - 1:0];
reg [FIFO_DEPTH - 1:0] rd_ptr, wr_ptr, depth_cnt;

// PUSH
always @(posedge clk) begin
    if (reset) begin
        wr_ptr <= 0;
    end
    else begin
        if (wr_en && !Full) begin
            memory[wr_ptr] <= Data_In;
            wr_ptr <= wr_ptr + 1;
        end
    end
end

// POP
always @(posedge clk) begin
    if (reset) begin
        rd_ptr <= 0;
    end
    else begin
        if (rd_en && !Empty) begin
            Data_out <= memory[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end
end

// Depth Count
always @(posedge clk) begin
    if (reset) begin
        depth_cnt <= 0;
    end
    else begin
        if (wr_en && !Full)
            depth_cnt <= depth_cnt + 1;
        else if (rd_en && !Empty)
            depth_cnt <= depth_cnt - 1;
        // Add one more condition to check simultaneous WR & RD
    end
end

assign Empty = (depth_cnt == 0) ? 1 : 0;
assign Full = (depth_cnt == FIFO_DEPTH) ? 1 : 0;

endmodule
