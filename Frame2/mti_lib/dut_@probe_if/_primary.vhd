library verilog;
use verilog.vl_types.all;
entity dut_Probe_if is
    port(
        fetch_enable_updatePC: in     vl_logic;
        fetch_enable_fetch: in     vl_logic;
        fetch_br_taken  : in     vl_logic;
        fetch_taddr     : in     vl_logic_vector(15 downto 0);
        fetch_instrmem_rd: in     vl_logic;
        fetch_pc        : in     vl_logic_vector(15 downto 0);
        fetch_npc_out   : in     vl_logic_vector(15 downto 0)
    );
end dut_Probe_if;
