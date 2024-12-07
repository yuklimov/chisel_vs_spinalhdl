-- Generator : SpinalHDL v1.10.2a    git head : a348a60b7e8b6a455c72e1536ec3d74a2ea16935
-- Component : FIFO
-- Git hash  : f7e15f90abfcb78b704d1b1854e90711fa0c129b

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

package pkg_enum is

end pkg_enum;

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package pkg_scala2hdl is
  function pkg_extract (that : std_logic_vector; bitId : integer) return std_logic;
  function pkg_extract (that : std_logic_vector; base : unsigned; size : integer) return std_logic_vector;
  function pkg_cat (a : std_logic_vector; b : std_logic_vector) return std_logic_vector;
  function pkg_not (value : std_logic_vector) return std_logic_vector;
  function pkg_extract (that : unsigned; bitId : integer) return std_logic;
  function pkg_extract (that : unsigned; base : unsigned; size : integer) return unsigned;
  function pkg_cat (a : unsigned; b : unsigned) return unsigned;
  function pkg_not (value : unsigned) return unsigned;
  function pkg_extract (that : signed; bitId : integer) return std_logic;
  function pkg_extract (that : signed; base : unsigned; size : integer) return signed;
  function pkg_cat (a : signed; b : signed) return signed;
  function pkg_not (value : signed) return signed;

  function pkg_mux (sel : std_logic; one : std_logic; zero : std_logic) return std_logic;
  function pkg_mux (sel : std_logic; one : std_logic_vector; zero : std_logic_vector) return std_logic_vector;
  function pkg_mux (sel : std_logic; one : unsigned; zero : unsigned) return unsigned;
  function pkg_mux (sel : std_logic; one : signed; zero : signed) return signed;

  function pkg_toStdLogic (value : boolean) return std_logic;
  function pkg_toStdLogicVector (value : std_logic) return std_logic_vector;
  function pkg_toUnsigned (value : std_logic) return unsigned;
  function pkg_toSigned (value : std_logic) return signed;
  function pkg_stdLogicVector (lit : std_logic_vector) return std_logic_vector;
  function pkg_unsigned (lit : unsigned) return unsigned;
  function pkg_signed (lit : signed) return signed;

  function pkg_resize (that : std_logic_vector; width : integer) return std_logic_vector;
  function pkg_resize (that : unsigned; width : integer) return unsigned;
  function pkg_resize (that : signed; width : integer) return signed;

  function pkg_extract (that : std_logic_vector; high : integer; low : integer) return std_logic_vector;
  function pkg_extract (that : unsigned; high : integer; low : integer) return unsigned;
  function pkg_extract (that : signed; high : integer; low : integer) return signed;

  function pkg_shiftRight (that : std_logic_vector; size : natural) return std_logic_vector;
  function pkg_shiftRight (that : std_logic_vector; size : unsigned) return std_logic_vector;
  function pkg_shiftLeft (that : std_logic_vector; size : natural) return std_logic_vector;
  function pkg_shiftLeft (that : std_logic_vector; size : unsigned) return std_logic_vector;

  function pkg_shiftRight (that : unsigned; size : natural) return unsigned;
  function pkg_shiftRight (that : unsigned; size : unsigned) return unsigned;
  function pkg_shiftLeft (that : unsigned; size : natural) return unsigned;
  function pkg_shiftLeft (that : unsigned; size : unsigned) return unsigned;

  function pkg_shiftRight (that : signed; size : natural) return signed;
  function pkg_shiftRight (that : signed; size : unsigned) return signed;
  function pkg_shiftLeft (that : signed; size : natural) return signed;
  function pkg_shiftLeft (that : signed; size : unsigned; w : integer) return signed;

  function pkg_rotateLeft (that : std_logic_vector; size : unsigned) return std_logic_vector;
end  pkg_scala2hdl;

package body pkg_scala2hdl is
  function pkg_extract (that : std_logic_vector; bitId : integer) return std_logic is
    alias temp : std_logic_vector(that'length-1 downto 0) is that;
  begin
    if bitId >= temp'length then
      return 'U';
    end if;
    return temp(bitId);
  end pkg_extract;

  function pkg_extract (that : std_logic_vector; base : unsigned; size : integer) return std_logic_vector is
    alias temp : std_logic_vector(that'length-1 downto 0) is that;    constant elementCount : integer := temp'length - size + 1;
    type tableType is array (0 to elementCount-1) of std_logic_vector(size-1 downto 0);
    variable table : tableType;
  begin
    for i in 0 to elementCount-1 loop
      table(i) := temp(i + size - 1 downto i);
    end loop;
    if base + size >= elementCount then
      return (size-1 downto 0 => 'U');
    end if;
    return table(to_integer(base));
  end pkg_extract;

  function pkg_cat (a : std_logic_vector; b : std_logic_vector) return std_logic_vector is
    variable cat : std_logic_vector(a'length + b'length-1 downto 0);
  begin
    cat := a & b;
    return cat;
  end pkg_cat;

  function pkg_not (value : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(value'length-1 downto 0);
  begin
    ret := not value;
    return ret;
  end pkg_not;

  function pkg_extract (that : unsigned; bitId : integer) return std_logic is
    alias temp : unsigned(that'length-1 downto 0) is that;
  begin
    if bitId >= temp'length then
      return 'U';
    end if;
    return temp(bitId);
  end pkg_extract;

  function pkg_extract (that : unsigned; base : unsigned; size : integer) return unsigned is
    alias temp : unsigned(that'length-1 downto 0) is that;    constant elementCount : integer := temp'length - size + 1;
    type tableType is array (0 to elementCount-1) of unsigned(size-1 downto 0);
    variable table : tableType;
  begin
    for i in 0 to elementCount-1 loop
      table(i) := temp(i + size - 1 downto i);
    end loop;
    if base + size >= elementCount then
      return (size-1 downto 0 => 'U');
    end if;
    return table(to_integer(base));
  end pkg_extract;

  function pkg_cat (a : unsigned; b : unsigned) return unsigned is
    variable cat : unsigned(a'length + b'length-1 downto 0);
  begin
    cat := a & b;
    return cat;
  end pkg_cat;

  function pkg_not (value : unsigned) return unsigned is
    variable ret : unsigned(value'length-1 downto 0);
  begin
    ret := not value;
    return ret;
  end pkg_not;

  function pkg_extract (that : signed; bitId : integer) return std_logic is
    alias temp : signed(that'length-1 downto 0) is that;
  begin
    if bitId >= temp'length then
      return 'U';
    end if;
    return temp(bitId);
  end pkg_extract;

  function pkg_extract (that : signed; base : unsigned; size : integer) return signed is
    alias temp : signed(that'length-1 downto 0) is that;    constant elementCount : integer := temp'length - size + 1;
    type tableType is array (0 to elementCount-1) of signed(size-1 downto 0);
    variable table : tableType;
  begin
    for i in 0 to elementCount-1 loop
      table(i) := temp(i + size - 1 downto i);
    end loop;
    if base + size >= elementCount then
      return (size-1 downto 0 => 'U');
    end if;
    return table(to_integer(base));
  end pkg_extract;

  function pkg_cat (a : signed; b : signed) return signed is
    variable cat : signed(a'length + b'length-1 downto 0);
  begin
    cat := a & b;
    return cat;
  end pkg_cat;

  function pkg_not (value : signed) return signed is
    variable ret : signed(value'length-1 downto 0);
  begin
    ret := not value;
    return ret;
  end pkg_not;


  -- unsigned shifts
  function pkg_shiftRight (that : unsigned; size : natural) return unsigned is
    variable ret : unsigned(that'length-1 downto 0);
  begin
    if size >= that'length then
      return "";
    else
      ret := shift_right(that,size);
      return ret(that'length-1-size downto 0);
    end if;
  end pkg_shiftRight;

  function pkg_shiftRight (that : unsigned; size : unsigned) return unsigned is
    variable ret : unsigned(that'length-1 downto 0);
  begin
    ret := shift_right(that,to_integer(size));
    return ret;
  end pkg_shiftRight;

  function pkg_shiftLeft (that : unsigned; size : natural) return unsigned is
  begin
    return shift_left(resize(that,that'length + size),size);
  end pkg_shiftLeft;

  function pkg_shiftLeft (that : unsigned; size : unsigned) return unsigned is
  begin
    return shift_left(resize(that,that'length + 2**size'length - 1),to_integer(size));
  end pkg_shiftLeft;

  -- std_logic_vector shifts
  function pkg_shiftRight (that : std_logic_vector; size : natural) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftRight(unsigned(that),size));
  end pkg_shiftRight;

  function pkg_shiftRight (that : std_logic_vector; size : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftRight(unsigned(that),size));
  end pkg_shiftRight;

  function pkg_shiftLeft (that : std_logic_vector; size : natural) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftLeft(unsigned(that),size));
  end pkg_shiftLeft;

  function pkg_shiftLeft (that : std_logic_vector; size : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftLeft(unsigned(that),size));
  end pkg_shiftLeft;

  -- signed shifts
  function pkg_shiftRight (that : signed; size : natural) return signed is
  begin
    return signed(pkg_shiftRight(unsigned(that),size));
  end pkg_shiftRight;

  function pkg_shiftRight (that : signed; size : unsigned) return signed is
  begin
    return shift_right(that,to_integer(size));
  end pkg_shiftRight;

  function pkg_shiftLeft (that : signed; size : natural) return signed is
  begin
    return signed(pkg_shiftLeft(unsigned(that),size));
  end pkg_shiftLeft;

  function pkg_shiftLeft (that : signed; size : unsigned; w : integer) return signed is
  begin
    return shift_left(resize(that,w),to_integer(size));
  end pkg_shiftLeft;

  function pkg_rotateLeft (that : std_logic_vector; size : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(rotate_left(unsigned(that),to_integer(size)));
  end pkg_rotateLeft;

  function pkg_extract (that : std_logic_vector; high : integer; low : integer) return std_logic_vector is
    alias temp : std_logic_vector(that'length-1 downto 0) is that;
  begin
    return temp(high downto low);
  end pkg_extract;

  function pkg_extract (that : unsigned; high : integer; low : integer) return unsigned is
    alias temp : unsigned(that'length-1 downto 0) is that;
  begin
    return temp(high downto low);
  end pkg_extract;

  function pkg_extract (that : signed; high : integer; low : integer) return signed is
    alias temp : signed(that'length-1 downto 0) is that;
  begin
    return temp(high downto low);
  end pkg_extract;

  function pkg_mux (sel : std_logic; one : std_logic; zero : std_logic) return std_logic is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : std_logic_vector; zero : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(zero'range);
  begin
    if sel = '1' then
      ret := one;
    else
      ret := zero;
    end if;
    return ret;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : unsigned; zero : unsigned) return unsigned is
    variable ret : unsigned(zero'range);
  begin
    if sel = '1' then
      ret := one;
    else
      ret := zero;
    end if;
    return ret;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : signed; zero : signed) return signed is
    variable ret : signed(zero'range);
  begin
    if sel = '1' then
      ret := one;
    else
      ret := zero;
    end if;
    return ret;
  end pkg_mux;

  function pkg_toStdLogic (value : boolean) return std_logic is
  begin
    if value = true then
      return '1';
    else
      return '0';
    end if;
  end pkg_toStdLogic;

  function pkg_toStdLogicVector (value : std_logic) return std_logic_vector is
    variable ret : std_logic_vector(0 downto 0);
  begin
    ret(0) := value;
    return ret;
  end pkg_toStdLogicVector;

  function pkg_toUnsigned (value : std_logic) return unsigned is
    variable ret : unsigned(0 downto 0);
  begin
    ret(0) := value;
    return ret;
  end pkg_toUnsigned;

  function pkg_toSigned (value : std_logic) return signed is
    variable ret : signed(0 downto 0);
  begin
    ret(0) := value;
    return ret;
  end pkg_toSigned;

  function pkg_stdLogicVector (lit : std_logic_vector) return std_logic_vector is
    alias ret : std_logic_vector(lit'length-1 downto 0) is lit;
  begin
    return std_logic_vector(ret);
  end pkg_stdLogicVector;

  function pkg_unsigned (lit : unsigned) return unsigned is
    alias ret : unsigned(lit'length-1 downto 0) is lit;
  begin
    return unsigned(ret);
  end pkg_unsigned;

  function pkg_signed (lit : signed) return signed is
    alias ret : signed(lit'length-1 downto 0) is lit;
  begin
    return signed(ret);
  end pkg_signed;

  function pkg_resize (that : std_logic_vector; width : integer) return std_logic_vector is
  begin
    return std_logic_vector(resize(unsigned(that),width));
  end pkg_resize;

  function pkg_resize (that : unsigned; width : integer) return unsigned is
    variable ret : unsigned(width-1 downto 0);
  begin
    if that'length = 0 then
       ret := (others => '0');
    else
       ret := resize(that,width);
    end if;
    return ret;
  end pkg_resize;
  function pkg_resize (that : signed; width : integer) return signed is
    alias temp : signed(that'length-1 downto 0) is that;
    variable ret : signed(width-1 downto 0);
  begin
    if temp'length = 0 then
       ret := (others => '0');
    elsif temp'length >= width then
       ret := temp(width-1 downto 0);
    else
       ret := resize(temp,width);
    end if;
    return ret;
  end pkg_resize;
end pkg_scala2hdl;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity WrCntr is
  port(
    i_port_vdata_data : in std_logic_vector(15 downto 0);
    i_port_vdata_valid : in std_logic;
    i_port_ready : out std_logic;
    o_mem_addr : out unsigned(4 downto 0);
    o_mem_data : out std_logic_vector(15 downto 0);
    o_mem_en : out std_logic;
    i_addr : in unsigned(5 downto 0);
    o_addr : out unsigned(5 downto 0);
    clk : in std_logic;
    reset : in std_logic
  );
end WrCntr;

architecture arch of WrCntr is
  signal o_mem_en_read_buffer : std_logic;
  signal i_port_ready_read_buffer : std_logic;

  signal addr : unsigned(5 downto 0);
begin
  o_mem_en <= o_mem_en_read_buffer;
  i_port_ready <= i_port_ready_read_buffer;
  i_port_ready_read_buffer <= pkg_toStdLogic(addr /= (i_addr + pkg_unsigned("100000")));
  o_mem_addr <= pkg_resize(addr,5);
  o_mem_data <= i_port_vdata_data;
  o_mem_en_read_buffer <= (i_port_ready_read_buffer and i_port_vdata_valid);
  o_addr <= addr;
  process(clk, reset)
  begin
    if reset = '1' then
      addr <= pkg_unsigned("000000");
    elsif rising_edge(clk) then
      if o_mem_en_read_buffer = '1' then
        addr <= (addr + pkg_unsigned("000001"));
      end if;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity RdCntr is
  port(
    o_port_vdata_data : out std_logic_vector(15 downto 0);
    o_port_vdata_valid : out std_logic;
    o_port_ready : in std_logic;
    o_mem_addr : out unsigned(4 downto 0);
    o_mem_data : in std_logic_vector(15 downto 0);
    o_mem_en : out std_logic;
    i_addr : in unsigned(5 downto 0);
    o_addr : out unsigned(5 downto 0);
    clk : in std_logic;
    reset : in std_logic
  );
end RdCntr;

architecture arch of RdCntr is
  signal o_mem_en_read_buffer : std_logic;

  signal addr : unsigned(5 downto 0);
  signal buf0_data : std_logic_vector(15 downto 0);
  signal buf0_valid : std_logic;
  signal o_mem_en_regNext : std_logic;
  signal buf1_data : std_logic_vector(15 downto 0);
  signal buf1_valid : std_logic;
  signal buf2_data : std_logic_vector(15 downto 0);
  signal buf2_valid : std_logic;
  signal when_FIFO_l75 : std_logic;
  signal when_FIFO_l81 : std_logic;
begin
  o_mem_en <= o_mem_en_read_buffer;
  buf0_data <= o_mem_data;
  buf0_valid <= o_mem_en_regNext;
  when_FIFO_l75 <= (buf0_valid or (not buf2_valid));
  when_FIFO_l81 <= (not buf2_valid);
  o_mem_addr <= pkg_resize(addr,5);
  o_mem_en_read_buffer <= (pkg_toStdLogic(addr /= i_addr) and ((o_port_ready or pkg_toStdLogic(((buf0_valid or buf1_valid) or buf2_valid) = pkg_toStdLogic(false))) or (pkg_toStdLogic(((buf0_valid xor buf1_valid) xor buf1_valid) = pkg_toStdLogic(true)) and pkg_toStdLogic(((buf0_valid and buf1_valid) and buf1_valid) = pkg_toStdLogic(false)))));
  o_port_vdata_data <= pkg_mux(buf2_valid,buf2_data,buf1_data);
  o_port_vdata_valid <= pkg_mux(buf2_valid,buf2_valid,buf1_valid);
  o_addr <= addr;
  process(clk, reset)
  begin
    if reset = '1' then
      addr <= pkg_unsigned("000000");
      o_mem_en_regNext <= pkg_toStdLogic(false);
      buf1_valid <= pkg_toStdLogic(false);
      buf2_data <= pkg_stdLogicVector("XXXXXXXXXXXXXXXX");
      buf2_valid <= pkg_toStdLogic(false);
    elsif rising_edge(clk) then
      if o_mem_en_read_buffer = '1' then
        addr <= (addr + pkg_unsigned("000001"));
      end if;
      o_mem_en_regNext <= o_mem_en_read_buffer;
      if when_FIFO_l75 = '1' then
        buf1_valid <= buf0_valid;
      end if;
      if o_port_ready = '1' then
        buf2_valid <= pkg_toStdLogic(false);
      else
        if when_FIFO_l81 = '1' then
          buf2_data <= buf1_data;
          buf2_valid <= buf1_valid;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if when_FIFO_l75 = '1' then
        buf1_data <= buf0_data;
      end if;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity FIFO is
  port(
    i_port_vdata_data : in std_logic_vector(15 downto 0);
    i_port_vdata_valid : in std_logic;
    i_port_ready : out std_logic;
    o_port_vdata_data : out std_logic_vector(15 downto 0);
    o_port_vdata_valid : out std_logic;
    o_port_ready : in std_logic;
    clk : in std_logic;
    reset : in std_logic
  );
end FIFO;

architecture arch of FIFO is
  signal rctrl_o_mem_data : std_logic_vector(15 downto 0);
  signal mem_spinal_port1 : std_logic_vector(15 downto 0);
  signal wctrl_i_port_ready : std_logic;
  signal wctrl_o_mem_addr : unsigned(4 downto 0);
  signal wctrl_o_mem_data : std_logic_vector(15 downto 0);
  signal wctrl_o_mem_en : std_logic;
  signal wctrl_o_addr : unsigned(5 downto 0);
  signal rctrl_o_port_vdata_data : std_logic_vector(15 downto 0);
  signal rctrl_o_port_vdata_valid : std_logic;
  signal rctrl_o_mem_addr : unsigned(4 downto 0);
  signal rctrl_o_mem_en : std_logic;
  signal rctrl_o_addr : unsigned(5 downto 0);

  type mem_type is array (0 to 31) of std_logic_vector(15 downto 0);
  signal mem : mem_type;
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if wctrl_o_mem_en = '1' then
        mem(to_integer(wctrl_o_mem_addr)) <= wctrl_o_mem_data;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if rctrl_o_mem_en = '1' then
        mem_spinal_port1 <= mem(to_integer(rctrl_o_mem_addr));
      end if;
    end if;
  end process;

  wctrl : entity work.WrCntr
    port map ( 
      i_port_vdata_data => i_port_vdata_data,
      i_port_vdata_valid => i_port_vdata_valid,
      i_port_ready => wctrl_i_port_ready,
      o_mem_addr => wctrl_o_mem_addr,
      o_mem_data => wctrl_o_mem_data,
      o_mem_en => wctrl_o_mem_en,
      i_addr => rctrl_o_addr,
      o_addr => wctrl_o_addr,
      clk => clk,
      reset => reset 
    );
  rctrl : entity work.RdCntr
    port map ( 
      o_port_vdata_data => rctrl_o_port_vdata_data,
      o_port_vdata_valid => rctrl_o_port_vdata_valid,
      o_port_ready => o_port_ready,
      o_mem_addr => rctrl_o_mem_addr,
      o_mem_data => rctrl_o_mem_data,
      o_mem_en => rctrl_o_mem_en,
      i_addr => wctrl_o_addr,
      o_addr => rctrl_o_addr,
      clk => clk,
      reset => reset 
    );
  i_port_ready <= wctrl_i_port_ready;
  o_port_vdata_data <= rctrl_o_port_vdata_data;
  o_port_vdata_valid <= rctrl_o_port_vdata_valid;
  rctrl_o_mem_data <= mem_spinal_port1;
end arch;

