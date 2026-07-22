-- test/example_spec.lua
-- Example test file demonstrating the test structure

local lu = require('luaunit')
local config = require('iedit.config')
local util = require('iedit.util')

TestExample = {}

function TestExample:setUp()
  -- Called before each test
end

function TestExample:tearDown()
  -- Called after each test
end

function TestExample:test_config_setup_returns_defaults()
  config.setup({})
  local cfg = config.get()
  lu.assertNotNil(cfg)
  lu.assertNotNil(cfg.highlight)
  lu.assertNotNil(cfg.highlight.active)
  lu.assertNotNil(cfg.highlight.current)
  lu.assertNotNil(cfg.highlight.inactive)
end

function TestExample:test_config_default_highlight_values()
  config.setup({})
  local cfg = config.get()
  lu.assertEquals(cfg.highlight.active.guifg, '#d3869b')
  lu.assertEquals(cfg.highlight.current.guifg, '#83a598')
  lu.assertEquals(cfg.highlight.inactive.guifg, '#abb2bf')
end

function TestExample:test_util_toggle_case()
  lu.assertEquals(util.toggle_case('a'), 'A')
  lu.assertEquals(util.toggle_case('A'), 'a')
end

return TestExample

