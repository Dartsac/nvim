local cb = require("colorbuddy.init")

-- Loading the colorscheme using vim.cmd but then using colorbuddy to override colors and groups
local colorscheme = "dracula_pro_buffy"
local status_ok, err = pcall(function()
	vim.cmd("colorscheme " .. colorscheme)
end)
if not status_ok then
	vim.notify("Failed to load colorscheme: " .. colorscheme .. "\n" .. err, vim.log.levels.ERROR)
	return
end

local Color = cb.Color
local colors = cb.colors
local Group = cb.Group
local groups = cb.groups
local styles = cb.styles

-- Color.new("fg", "#F8F8F2")
-- Color.new("bglighter", "#463649")
-- Color.new("bglight", "#382B3B")
Color.new("thisBg", "#2A212C")
Color.new("thisBgDark", "#1C161D")
Color.new("thisBgDarker", "#0B0B0F")
-- Color.new("comment", "#9F70A9")
Color.new("thisSelection", "#454158")
-- Color.new("subtle", "#424450")
Color.new("thisCyan", "#80FFEA")
Color.new("thisBlue", "#7970A9")
-- Color.new("green", "#8AFF80")
-- Color.new("orange", "#FFCA80")
-- Color.new("pink", "#FF80BF")
-- Color.new("purple", "#9580FF")
Color.new("thisRed", "#FF9580")
Color.new("thisYellow", "#FFFF80")

Group.new("Error", colors.thisRed)
Group.new("Warning", colors.thisYellow)
Group.new("Information", colors.thisBlue)
Group.new("Hint", colors.thisCyan)

Group.new("CursorLine", colors.none, colors.thisBgDark, styles.NONE, colors.thisSelection)
Group.new("CursorLineNr", colors.thisYellow, colors.thisBgDarker, styles.NONE, colors.thisSelection)
Group.new("Visual", colors.none, colors.thisBg, styles.reverse)

local cError = groups.Error.fg
local cInfo = groups.Information.fg
local cWarn = groups.Warning.fg
local cHint = groups.Hint.fg

Group.new("DiagnosticVirtualTextError", colors.white, cError, styles.NONE)
Group.new("DiagnosticVirtualTextWarn", colors.thisBgDarker, cWarn, styles.NONE)
Group.new("DiagnosticVirtualTextInfo", colors.thisBgDarker, cInfo, styles.NONE)
Group.new("DiagnosticVirtualTextHint", colors.thisBgDarker, cHint, styles.NONE)

Group.new("DiagnosticUnderlineError", colors.none, colors.none, styles.undercurl, cError)
Group.new("DiagnosticUnderlineWarn", colors.none, colors.none, styles.undercurl, cWarn)
Group.new("DiagnosticUnderlineInfo", colors.none, colors.none, styles.undercurl, cInfo)
Group.new("DiagnosticUnderlineHint", colors.none, colors.none, styles.undercurl, cHint)
