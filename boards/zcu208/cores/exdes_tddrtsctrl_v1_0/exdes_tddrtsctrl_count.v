// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2024 Advanced Micro Devices, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.

//----------------------------------------------------------------------------
// Title : RF Analyzer TDD control counter
// Project : Ultrascale+ RF Data Converter Subsystem
//----------------------------------------------------------------------------
//

`timescale 1ps/1ps

(* DowngradeIPIdentifiedWarnings="yes" *)
module exdes_tddrtsctrl_count #(
    parameter C_COUNT_WIDTH      = 19)
(
    input  wire                     s_axi_aclk,
    input  wire                     sync_clk,
    input  wire [C_COUNT_WIDTH-1:0] delay,
    input  wire                     trigger,
    output reg                      enable
);

   reg  enable_sig;
   (* ASYNC_REG = "true" *) reg enable_meta;
   (* ASYNC_REG = "true" *) reg enable_sync;
   reg  [C_COUNT_WIDTH-1:0] count = 'd0;
    
   // Count to delay value when trigger asserted
   // Assert enable when count value reached
   // Reset when trigger de-asserted
   always @(posedge s_axi_aclk) begin
     if (trigger == 1'b1) begin
        count <= 'd0;
        enable_sig <= 1'b0;
     end
     else begin
        if (count == delay) begin
           count  <= count;
           enable_sig <= 1'b1;
        end
        else begin
           count <= count + 1;
           enable_sig <= 1'b0;
        end
     end
   end
   
   // Synchronise to appropriate clock domain
   always @(posedge sync_clk) begin
     enable_meta <= enable_sig;
     enable_sync <= enable_meta;
     enable      <= enable_sync;
   end   
   
endmodule
