-- test/util_spec.lua
-- Tests for iedit.util module - all public functions

local lu = require('luaunit')
local util = require('iedit.util')

TestUtil = {}

-- ============================================================
-- M.toggle_case(str)
-- ============================================================

function TestUtil:test_toggle_case_lower_to_upper()
  lu.assertEquals(util.toggle_case('a'), 'A')
  lu.assertEquals(util.toggle_case('z'), 'Z')
  lu.assertEquals(util.toggle_case('hello'), 'HELLO')
end

function TestUtil:test_toggle_case_upper_to_lower()
  lu.assertEquals(util.toggle_case('A'), 'a')
  lu.assertEquals(util.toggle_case('Z'), 'z')
  lu.assertEquals(util.toggle_case('HELLO'), 'hello')
end

function TestUtil:test_toggle_case_mixed()
  lu.assertEquals(util.toggle_case('Hello'), 'hELLO')
  lu.assertEquals(util.toggle_case('AbCdEf'), 'aBcDeF')
end

function TestUtil:test_toggle_case_non_alpha()
  lu.assertEquals(util.toggle_case('123'), '123')
  lu.assertEquals(util.toggle_case('a1b2'), 'A1B2')
  lu.assertEquals(util.toggle_case('!@#'), '!@#')
end

function TestUtil:test_toggle_case_empty()
  lu.assertEquals(util.toggle_case(''), '')
end

function TestUtil:test_toggle_case_single_chars()
  for c = 97, 122 do
    local ch = string.char(c)
    lu.assertEquals(util.toggle_case(ch), string.char(c - 32))
  end
  for c = 65, 90 do
    local ch = string.char(c)
    lu.assertEquals(util.toggle_case(ch), string.char(c + 32))
  end
end

-- ============================================================
-- M.string2chars(str)
-- ============================================================

function TestUtil:test_string2chars_basic()
  local chars = util.string2chars('hello')
  lu.assertEquals(#chars, 5)
  lu.assertEquals(chars[1], 'h')
  lu.assertEquals(chars[2], 'e')
  lu.assertEquals(chars[3], 'l')
  lu.assertEquals(chars[4], 'l')
  lu.assertEquals(chars[5], 'o')
end

function TestUtil:test_string2chars_empty()
  local chars = util.string2chars('')
  lu.assertEquals(#chars, 0)
end

function TestUtil:test_string2chars_single()
  local chars = util.string2chars('x')
  lu.assertEquals(#chars, 1)
  lu.assertEquals(chars[1], 'x')
end

function TestUtil:test_string2chars_special()
  local chars = util.string2chars('a b')
  lu.assertEquals(#chars, 3)
  lu.assertEquals(chars[2], ' ')
end

function TestUtil:test_string2chars_multibyte()
  local chars = util.string2chars('你好')
  lu.assertEquals(#chars, 6) -- UTF-8: each Chinese char is 3 bytes
end

-- ============================================================
-- M.matchstrpos(str, need, ...)
-- ============================================================

function TestUtil:test_matchstrpos_basic()
  local result = util.matchstrpos('hello world', 'world')
  lu.assertEquals(result[1], 'world')  -- matched string
  lu.assertEquals(result[2], 6)         -- match begin (0-indexed)
  lu.assertEquals(result[3], 11)        -- match end
end

function TestUtil:test_matchstrpos_no_match()
  local result = util.matchstrpos('hello', 'xyz')
  lu.assertEquals(result[1], '')
  lu.assertEquals(result[2], -1)
  lu.assertEquals(result[3], -1)
end

function TestUtil:test_matchstrpos_at_start()
  local result = util.matchstrpos('hello world', 'hello')
  lu.assertEquals(result[1], 'hello')
  lu.assertEquals(result[2], 0)
  lu.assertEquals(result[3], 5)
end

function TestUtil:test_matchstrpos_with_offset()
  local result = util.matchstrpos('hello hello', 'hello', 3)
  lu.assertEquals(result[1], 'hello')
  lu.assertEquals(result[2], 6)
  lu.assertEquals(result[3], 11)
end

function TestUtil:test_matchstrpos_empty_needle()
  local result = util.matchstrpos('hello', '')
  -- empty pattern matches at position 0
  lu.assertNotNil(result)
end

function TestUtil:test_matchstrpos_regex()
  local result = util.matchstrpos('hello 123 world', '\\d\\+')
  lu.assertEquals(result[1], '123')
  lu.assertEquals(result[2], 6)
  lu.assertEquals(result[3], 9)
end

-- ============================================================
-- M.strAllIndex(str, need, use_expr)
-- ============================================================

function TestUtil:test_strAllIndex_no_expr_single()
  local result = util.strAllIndex('hello world hello', 'hello', 0)
  lu.assertNotNil(result)
  lu.assertTrue(#result >= 1)
  -- First match should be at position 0
  lu.assertEquals(result[1][1], 0)
  lu.assertEquals(result[1][2], 5)
end

function TestUtil:test_strAllIndex_no_expr_multiple()
  local result = util.strAllIndex('foo bar foo bar foo', 'foo', 0)
  lu.assertTrue(#result >= 2)
  -- All matches should start at correct positions
  lu.assertEquals(result[1][1], 0)
  lu.assertEquals(result[2][1], 8)
  if #result >= 3 then
    lu.assertEquals(result[3][1], 16)
  end
end

function TestUtil:test_strAllIndex_no_expr_no_match()
  local result = util.strAllIndex('hello world', 'xyz', 0)
  lu.assertEquals(#result, 0)
end

function TestUtil:test_strAllIndex_expr_single()
  local result = util.strAllIndex('hello 123 world', '\\d\\+', 1)
  lu.assertEquals(#result, 1)
  lu.assertEquals(result[1][1], 6)
  lu.assertEquals(result[1][2], 9)
end

function TestUtil:test_strAllIndex_expr_multiple()
  local result = util.strAllIndex('123 abc 456', '\\d\\+', 1)
  lu.assertEquals(#result, 2)
  lu.assertEquals(result[1][1], 0)
  lu.assertEquals(result[1][2], 3)
  lu.assertEquals(result[2][1], 8)
  lu.assertEquals(result[2][2], 11)
end

function TestUtil:test_strAllIndex_expr_no_match()
  local result = util.strAllIndex('hello world', '\\d\\+', 1)
  lu.assertEquals(#result, 0)
end

function TestUtil:test_strAllIndex_empty_string()
  local result = util.strAllIndex('', 'test', 0)
  lu.assertEquals(#result, 0)
end

function TestUtil:test_strAllIndex_word_boundary()
  -- With the pattern \<\Vneed\ze\W\|\<\Vneed\ze\$,
  -- "foo" in "foo bar foo" matches at both word-boundary positions
  local result = util.strAllIndex('foo bar foo', 'foo', 0)
  lu.assertTrue(#result >= 1)
  lu.assertEquals(result[1][1], 0)
  lu.assertEquals(result[1][2], 3)
  if #result >= 2 then
    lu.assertEquals(result[2][1], 8)
    lu.assertEquals(result[2][2], 11)
  end
end

function TestUtil:test_strAllIndex_partial_word_no_match()
  -- "xyz" should not match inside "xyzabc" (no word boundary after)
  -- but may match at "xyz" standalone
  local result = util.strAllIndex('xyzabc xyz', 'xyz', 0)
  -- Only the standalone "xyz" at end should match
  lu.assertTrue(#result >= 1)
  lu.assertEquals(result[#result][1], 7)
end

-- ============================================================
-- M.t(str)
-- ============================================================

function TestUtil:test_t_returns_string()
  local result = util.t('<Esc>')
  lu.assertEquals(type(result), 'string')
end

function TestUtil:test_t_esc()
  local result = util.t('<Esc>')
  lu.assertNotEquals(result, '<Esc>')
  lu.assertTrue(#result > 0)
end

function TestUtil:test_t_tab()
  local result = util.t('<tab>')
  lu.assertEquals(type(result), 'string')
  lu.assertNotEquals(result, '<tab>')
end

function TestUtil:test_t_ctrl_combo()
  local result = util.t('<C-w>')
  lu.assertEquals(type(result), 'string')
end

function TestUtil:test_t_left_right()
  lu.assertEquals(type(util.t('<left>')), 'string')
  lu.assertEquals(type(util.t('<right>')), 'string')
end

function TestUtil:test_t_bs()
  lu.assertEquals(type(util.t('<bs>')), 'string')
end

function TestUtil:test_t_regular_string()
  -- Regular characters should pass through
  local result = util.t('a')
  lu.assertEquals(result, 'a')
end

-- ============================================================
-- M.getchar(...)
-- ============================================================

function TestUtil:test_getchar_returns_string_type()
  -- We can't easily simulate key input, but we can test the function exists
  lu.assertNotNil(util.getchar)
  lu.assertEquals(type(util.getchar), 'function')
end

-- ============================================================
-- M.hi(info)
-- ============================================================

function TestUtil:test_hi_exists()
  lu.assertNotNil(util.hi)
  lu.assertEquals(type(util.hi), 'function')
end

function TestUtil:test_hi_empty_info_returns()
  -- Should not error on empty info
  util.hi({})
  -- Should not error on info without name
  util.hi({ ctermbg = '0' })
end

function TestUtil:test_hi_with_name()
  -- Should set highlight without error
  util.hi({
    name = 'TestHiGroup',
    ctermbg = '0',
    ctermfg = '1',
    guibg = '#000000',
    guifg = '#ffffff',
  })
  -- Verify the group was created
  local id = vim.fn.hlID('TestHiGroup')
  lu.assertTrue(id > 0)
end

function TestUtil:test_hi_with_styles()
  util.hi({
    name = 'TestHiStyle',
    bold = 1,
    italic = 1,
    guifg = '#ff0000',
  })
  local id = vim.fn.hlID('TestHiStyle')
  lu.assertTrue(id > 0)
end

function TestUtil:test_hi_with_blend()
  util.hi({
    name = 'TestHiBlend',
    blend = 50,
    guifg = '#00ff00',
  })
  local id = vim.fn.hlID('TestHiBlend')
  lu.assertTrue(id > 0)
end

-- ============================================================
-- M.group2dict(name)
-- ============================================================

function TestUtil:test_group2dict_returns_table()
  local result = util.group2dict('Normal')
  lu.assertNotNil(result)
  lu.assertEquals(type(result), 'table')
end

function TestUtil:test_group2dict_has_name()
  local result = util.group2dict('Normal')
  lu.assertNotNil(result.name)
end

function TestUtil:test_group2dict_invalid_returns_empty()
  local result = util.group2dict('NonExistentGroupXYZ123')
  lu.assertEquals(result.name, '')
  lu.assertEquals(result.ctermbg, '')
  lu.assertEquals(result.ctermfg, '')
end

function TestUtil:test_group2dict_keys()
  local result = util.group2dict('Normal')
  lu.assertNotNil(result.ctermbg)
  lu.assertNotNil(result.ctermfg)
  lu.assertNotNil(result.guibg)
  lu.assertNotNil(result.guifg)
  lu.assertNotNil(result.bold)
  lu.assertNotNil(result.italic)
  lu.assertNotNil(result.reverse)
  lu.assertNotNil(result.underline)
end

function TestUtil:test_group2dict_created_group()
  -- Create a group first
  util.hi({
    name = 'TestGroupForDict',
    guifg = '#abcdef',
    bold = 1,
  })
  local result = util.group2dict('TestGroupForDict')
  lu.assertNotEquals(result.name, '')
  lu.assertEquals(result.bold, '1')
end

-- ============================================================
-- M.hide_in_normal(name)
-- ============================================================

function TestUtil:test_hide_in_normal_exists()
  lu.assertNotNil(util.hide_in_normal)
  lu.assertEquals(type(util.hide_in_normal), 'function')
end

function TestUtil:test_hide_in_normal_valid_group()
  -- Should not error on a valid group
  util.hide_in_normal('Normal')
end

function TestUtil:test_hide_in_normal_invalid_group()
  -- Should not error on invalid group
  util.hide_in_normal('NonExistentGroupXYZ456')
end

return TestUtil

