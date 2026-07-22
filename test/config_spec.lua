-- test/config_spec.lua
-- Tests for iedit.config module

local lu = require('luaunit')
local config = require('iedit.config')

TestConfig = {}

function TestConfig:setUp()
  config.setup({})
end

-- ============================================================
-- M.setup(opt)
-- ============================================================

function TestConfig:test_setup_exists()
  lu.assertNotNil(config.setup)
  lu.assertEquals(type(config.setup), 'function')
end

function TestConfig:test_setup_with_nil()
  config.setup(nil)
  local cfg = config.get()
  lu.assertNotNil(cfg)
end

function TestConfig:test_setup_with_empty_table()
  config.setup({})
  local cfg = config.get()
  lu.assertNotNil(cfg)
end

-- ============================================================
-- M.get()
-- ============================================================

function TestConfig:test_get_returns_table()
  local cfg = config.get()
  lu.assertEquals(type(cfg), 'table')
end

function TestConfig:test_get_returns_highlight()
  local cfg = config.get()
  lu.assertNotNil(cfg.highlight)
  lu.assertEquals(type(cfg.highlight), 'table')
end

function TestConfig:test_get_has_active_highlight()
  local cfg = config.get()
  lu.assertNotNil(cfg.highlight.active)
end

function TestConfig:test_get_has_current_highlight()
  local cfg = config.get()
  lu.assertNotNil(cfg.highlight.current)
end

function TestConfig:test_get_has_inactive_highlight()
  local cfg = config.get()
  lu.assertNotNil(cfg.highlight.inactive)
end

-- ============================================================
-- Default highlight values
-- ============================================================

function TestConfig:test_default_active_highlight()
  local cfg = config.get()
  local active = cfg.highlight.active
  lu.assertEquals(active.guibg, '#3c3836')
  lu.assertEquals(active.guifg, '#d3869b')
  lu.assertEquals(active.ctermfg, 175)
  lu.assertEquals(active.bold, 1)
end

function TestConfig:test_default_current_highlight()
  local cfg = config.get()
  local current = cfg.highlight.current
  lu.assertEquals(current.guibg, '#3c3836')
  lu.assertEquals(current.guifg, '#83a598')
  lu.assertEquals(current.ctermfg, 109)
  lu.assertEquals(current.bold, 1)
end

function TestConfig:test_default_inactive_highlight()
  local cfg = config.get()
  local inactive = cfg.highlight.inactive
  lu.assertEquals(inactive.guibg, '#3c3836')
  lu.assertEquals(inactive.guifg, '#abb2bf')
  lu.assertEquals(inactive.ctermfg, 145)
  lu.assertEquals(inactive.bold, 1)
end

-- ============================================================
-- Consistency - get() should return same structure every time
-- ============================================================

function TestConfig:test_get_consistent()
  local cfg1 = config.get()
  local cfg2 = config.get()
  lu.assertEquals(cfg1.highlight.active.guifg, cfg2.highlight.active.guifg)
  lu.assertEquals(cfg1.highlight.current.guifg, cfg2.highlight.current.guifg)
  lu.assertEquals(cfg1.highlight.inactive.guifg, cfg2.highlight.inactive.guifg)
end

return TestConfig

