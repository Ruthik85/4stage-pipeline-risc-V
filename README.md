# 4stage-pipeline-risc-V
A 4-stage pipelined RISC-V processor designed in Verilog and simulated via ModelSim. Splits execution into Fetch, Decode, Execute, and Writeback stages to optimize clock frequency and throughput. Explores pipeline registers, hazard management, and waveform validation.

## 👨‍💻 How to Run and Simulate the Processor

Follow these steps to set up the project and verify the 4-stage pipeline execution using **ModelSim**:

### Prerequisites
* Ensure you have **ModelSim** (Intel FPGA Edition or Student/Starter Edition) installed.
* Ensure all source files (`.v`) from the `src/` and `sim/` directories are downloaded locally.

---

### Step-by-Step Execution Procedure

### 1. Create a New Project in ModelSim
* Open ModelSim and go to **File ➔ New ➔ Project...**
* Give your project a name (e.g., `riscv_4stage_pipeline`) and select a project location.
* Leave the default library name as `work` and click **OK**.

### 2. Add Source Files
* Click on **Add Existing File** and browse to add all your Verilog files:
  * Top-level module (e.g., `riscv_top.v`)
  * Sub-modules (`alu.v`, `control_unit.v`, `register_file.v`, and the newly added pipeline registers like `if_id_reg.v`, `id_ex_reg.v`, `ex_wb_reg.v`).
  * The testbench file (e.g., `riscv_tb.v`).

### 3. Compile the Design
* Right-click anywhere inside the Project workspace panel and select **Compile ➔ Compile All**.
* Ensure a green checkmark `✓` appears next to every file in the list. If any red `X` appears, check the *Transcript window* at the bottom for compilation syntax errors.

### 4. Start the Simulation
* Switch from the **Project** tab to the **Library** tab in the workspace panel.
* Expand the **work** library directory.
* Right-click on your testbench module (`riscv_tb`) and select **Simulate**.

### 5. Configure Waveforms for Pipeline Verification
To witness the 4-stage pipelining in action, you need to monitor how instructions move through the stages simultaneously:
* In the **Objects** window, select the key signals you want to analyze.
* Right-click them and select **Add to ➔ Wave ➔ Selected Signals**.
* **Recommended Signals to Watch:**
  * `clk` and `rst` (To trace clock edges).
  * `PC` (Program Counter tracking fetch progress).
  * `IF_ID_instruction` (Instruction currently being decoded).
  * `ID_EX_alu_out` (Result being computed in the execute stage).
  * `EX_WB_reg_write_data` (Data ready to be committed back to the register file).

### 6. Run the Simulation
* In the ModelSim command line toolbar, set the simulation time (e.g., `100ns` or `200ns`).
* Click the **Run** icon (or type `run 200ns` in the ModelSim terminal console).
* Zoom to fit the Wave window (`F9` or click the zoom-to-fit icon) to analyze the overlapping execution cycles. You should see a new instruction enter the Fetch stage on every consecutive clock edge!
