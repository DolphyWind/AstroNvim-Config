local H = {}

local ts = vim.treesitter
function get_node_at_cursor()
  -- Get the current cursor position (0-based line and column)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1  -- Convert to 0-indexing for Tree-sitter
  local col = cursor[2]

  -- Get the parser for the current buffer and language
  local parser = ts.get_parser(0) -- 0 means the current buffer
  local tree = parser:parse()[1]  -- Get the first syntax tree

  -- Get the root node of the syntax tree
  local root = tree:root()

  -- Find the node at the cursor position
  local node = root:named_descendant_for_range(row, col, row, col)

  return node
end

function get_node_lexeme(node)
  return ts.get_node_text(node, 0)
end

function find_children_with_type(node, type)
  local i = 1
  local children = {}
  for child in node:iter_children() do
    if child:type() == type then
      children[i] = child
      i = i + 1
    end
  end
  return children
end

function find_child_with_type(node, type)
  for child in node:iter_children() do
    if child:type() == type then
      return child
    end
  end
  return nil
end

-- @param node TSNode
-- @param type string
-- @return boolean
function has_child_with_type(node, type)
  return find_child_with_type(node, type) ~= nil
end

function H.generate_enum_tostring_array()
  local node = get_node_at_cursor()

  local found = false
  while node do
    if node:type() == 'enum_specifier' then
      found = true
      break
    end
    node = node:parent()
  end

  if not found then
    return
  end

  local is_cpp = vim.bo.filetype == 'cpp'
  local enum_node = node
  local type_id = find_child_with_type(node, 'type_identifier')
  node = find_child_with_type(node, 'enumerator_list')
  local children = find_children_with_type(node, 'enumerator')

  local text_list = { "" }

  local node_lexeme = get_node_lexeme(type_id)
  if is_cpp then
    table.insert(text_list, "static constexpr std::array<std::string, " .. #children .. "> " .. node_lexeme .. "_tostring = {")
  else
    table.insert(text_list, "static const char *" .. node_lexeme .. "_tostring[] = {")
  end

  for i, c in ipairs(children) do
    children[i] = find_child_with_type(c, 'identifier')
    table.insert(text_list, "   \"" .. get_node_lexeme(children[i]) .. "\",")
  end
  table.insert(text_list, "};")

  local end_row, end_col = enum_node:end_()
  local current_buffer = vim.api.nvim_get_current_buf()  -- Get the current buffer
  vim.api.nvim_buf_set_lines(current_buffer, end_row + 1, end_row + 1, false, text_list)  -- Insert the text
end

return H
