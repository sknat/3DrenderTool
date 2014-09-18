unit d3d_output;

interface
uses windows,graphics, sysutils,dialogs;
type T3dCanvas = class
    BackgroundColor: Tcolor;
    TargetCanvas: Tcanvas;
    end;

type T3dsurface = class
    
    procedure draw
    function CreateFromEQ(EQ: string;precision:integer):boolean;
    end;



implementation

end.
 