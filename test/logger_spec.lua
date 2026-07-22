-- test/logger_spec.lua
-- Tests for iedit.logger module

local lu = require('luaunit')
local logger = require('iedit.logger')

TestLogger = {}

-- ============================================================
-- M.debug(msg)
-- ============================================================

function TestLogger:test_debug_exists()
  lu.assertNotNil(logger.debug)
  lu.assertEquals(type(logger.debug), 'function')
end

function TestLogger:test_debug_with_string()
  -- Should not error even without logger.nvim installed
  logger.debug('test message')
end

function TestLogger:test_debug_with_empty_string()
  logger.debug('')
end

function TestLogger:test_debug_with_special_chars()
  logger.debug('test:>' .. 'hello' .. '<')
end

function TestLogger:test_debug_multiple_calls()
  logger.debug('first')
  logger.debug('second')
  logger.debug('third')
end

return TestLogger

