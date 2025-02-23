local Editor = SceneMachine.Editor;
local Resources = SceneMachine.Resources;

function Resources.Initialize(resourcePath)
    Resources.resourcePath = resourcePath;
    
    -- Fonts --
    Resources.fontsPath = Resources.resourcePath .. "\\font";

    Resources.fonts = {}
    Resources.fonts["Segoe"] = Resources.fontsPath .. "\\Segoe UI.ttf";
    Resources.fonts["Digital"] = Resources.fontsPath .. "\\digital-7.ttf";
    Resources.defaultFont = Resources.fonts["Segoe"];
    
    -- Textures --
    Resources.texturesPath = Resources.resourcePath .. "\\textures";
    Resources.textures = {}

    Resources.textures["SliderThumb"] = Resources.texturesPath .. "\\SliderThumb.png";
    Resources.textures["Keyframe"] = Resources.texturesPath .. "\\keyframe.png";
    Resources.textures["TimeSlider"] = Resources.texturesPath .. "\\timeSlider.png";
    Resources.textures["CloseButton"] = Resources.texturesPath .. "\\closeButton.png";
    Resources.textures["Line"] = Resources.texturesPath .. "\\line.png";
    Resources.textures["DashedLine"] = Resources.texturesPath .. "\\dashedLine.png";
    Resources.textures["Animation"] = Resources.texturesPath .. "\\animation.png";
    Resources.textures["CropBar"] = Resources.texturesPath .. "\\cropBar.png";
    Resources.textures["FolderIcon"] = Resources.texturesPath .. "\\folderIcon.png";
    Resources.textures["FolderUpIcon"] = Resources.texturesPath .. "\\folderUpIcon.png";
    Resources.textures["Icon32"] = Resources.texturesPath .. "\\icon32.png";
    Resources.textures["EyeIcon"] = Resources.texturesPath .. "\\eyeIcon.png";
    Resources.textures["ScrollBar"] = Resources.texturesPath .. "\\scrollBar.png";
    Resources.textures["Toolbar"] = Resources.texturesPath .. "\\toolbar.png";
    Resources.textures["DropShadow"] = Resources.texturesPath .. "\\dropShadowSquare.png";
    Resources.textures["CornerResize"] = Resources.texturesPath .. "\\cornerResize.png";
    Resources.textures["CursorResizeH"] = "interface\\cursor\\crosshair\\ui-cursor-move.blp";--Resources.texturesPath .. "\\resizeCursorHorizontal.png";
    Resources.textures["CursorResizeV"] = "interface\\cursor\\crosshair\\ui-cursor-move.blp";--Resources.texturesPath .. "\\resizeCursorVertical.png.crosshair";
    Resources.textures["CursorResize"] = "interface\\cursor\\crosshair\\ui-cursor-sizeright.blp";--Resources.texturesPath .. "\\resizeCursorBoth.png.crosshair";
    Resources.textures["ColorPicker"] = Resources.texturesPath .. "\\colorPickerV2.png";
    Resources.textures["KeyboardShortcuts"] = Resources.texturesPath .. "\\keyboardShortcuts.png";
end