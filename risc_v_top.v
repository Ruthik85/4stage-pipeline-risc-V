module risc_v_top (
    input clk,
    input reset
);
    // --- Pipeline Interconnect Wires ---
    wire [31:0] if_instr, id_instr;
    wire [31:0] pc_val;
    wire [31:0] rf_data1, rf_data2, id_imm_ext;
    
    // Control Unit Output Wires (ID Stage)
    wire [3:0]  id_alu_control;
    wire        id_alu_src, id_reg_write;

    // --- NEW: Wires emerging from ID_EX Register (EX Stage) ---
    wire [31:0] ex_reg_data1, ex_reg_data2, ex_imm_ext;
    wire [4:0]  ex_rd;
    wire [3:0]  ex_alu_control;
    wire        ex_alu_src, ex_reg_write;
    
    // Execution Output Wires (EX Stage)
    wire [31:0] alu_out;

    // Write-Back Stage Wires (WB Stage)
    wire [31:0] wb_data;
    wire [4:0]  wb_reg_addr;
    wire        wb_reg_write_en;

    // ==========================================
    // STAGE 1: FETCH
    // ==========================================
    IF_stage fetch (
        .clk(clk), .reset(reset), .PC(pc_val), .instr(if_instr)
    );

    IF_ID_reg p_reg1 (
        .clk(clk), .reset(reset), .instr_in(if_instr), .instr_out(id_instr)
    );

    // ==========================================
    // STAGE 2: DECODE
    // ==========================================
    control_unit cu (
        .opcode(id_instr[6:0]), .funct3(id_instr[14:12]), .funct7(id_instr[31:25]),
        .alu_control(id_alu_control), .alu_src(id_alu_src), .reg_write_en(id_reg_write)
    );

    Reg_File rf (
        .clk(clk), .reset(reset),
        .read_reg1(id_instr[19:15]), .read_reg2(id_instr[24:20]), 
        .write_reg(wb_reg_addr), .write_data(wb_data), .reg_write_en(wb_reg_write_en), 
        .read_data1(rf_data1), .read_data2(rf_data2)
    );

    assign id_imm_ext = {{20{id_instr[31]}}, id_instr[31:20]}; 

    // --- NEW: The Stage Breakpoint ---
    ID_EX_reg p_reg2 (
        .clk(clk), .reset(reset),
        .reg_data1_in(rf_data1), .reg_data2_in(rf_data2), .imm_ext_in(id_imm_ext),
        .rd_in(id_instr[11:7]), .alu_control_in(id_alu_control), .alu_src_in(id_alu_src), .reg_write_in(id_reg_write),
        
        .reg_data1_out(ex_reg_data1), .reg_data2_out(ex_reg_data2), .imm_ext_out(ex_imm_ext),
        .rd_out(ex_rd), .alu_control_out(ex_alu_control), .alu_src_out(ex_alu_src), .reg_write_out(ex_reg_write)
    );

    // ==========================================
    // STAGE 3: EXECUTE
    // ==========================================
    wire [31:0] alu_input_b;
    assign alu_input_b = (ex_alu_src) ? ex_imm_ext : ex_reg_data2;

    alu execution_unit (
        .a(ex_reg_data1), .b(alu_input_b), 
        .alu_control(ex_alu_control), .result(alu_out)
    );

    EX_WB_reg p_reg3 (
        .clk(clk), .reset(reset),
        .alu_result_in(alu_out), .write_reg_in(ex_rd), .reg_write_in(ex_reg_write),
        
        .alu_result_out(wb_data), .write_reg_out(wb_reg_addr), .reg_write_out(wb_reg_write_en)
    );

    // ==========================================
    // STAGE 4: WRITE BACK (Handled by loopback wires to 'rf')
    // ==========================================

endmodule
