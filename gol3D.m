% action:
% "stop" - Stops the simulation and updates its rules
% "start" - Starts the simulation
% "step" - Advances the simulation by one step
% "initialization" - Initializes the simulation (plot, cells, ui controls)
% "reset" - Resets the simulation (clears the cells array and clears the plot)
function gol3D(action)
if nargin<1
    action = "initialization";
end
% Radius of the voxels
radius = 0.5;
% The simulated space's dimension (length x length x length cube)
length = 11;
if strcmp(action,"initialization") | strcmp(action,"reset")
    neighborhood = 0;
    survival = [];
    birth = [];
    % Rules - (survival, birth, neighborhood)
    % Neighborhood values:
    % 1 - von Neumann neighborhood (6 cells checked)
    % 2 - radial neighborhood (18 cells checked)
    % 3 - Moore neighborhood (26 cells checked)
    if strcmp(action,"initialization")
        % Default rules
        neighborhood = 3;
        survival = [ 4 ];
        birth = [ 3 4 ];
    elseif neighborhood == 0 && isempty(survival) && isempty(birth)
        % Reset
        neighborhood = gcf().UserData.Neighborhood;
        survival = gcf().UserData.Survival;
        birth = gcf().UserData.Birth;
    end
    % The initialized center's width
    % max is length/2
    centerwidth = 1;
    % The initialized value that is used to fill the specified center width
    initvalue = 1;
    %initvalue = randi([0 1]); % - for randomized cells
    cells = zeros( length, length, length );
    for i = -round( centerwidth ):round( centerwidth )
        for j = -round( centerwidth ):round( centerwidth )
            for k = -round( centerwidth ):round( centerwidth )
                cells( round( length / 2 ) + i, round( length / 2 ) + j, round( length / 2 ) + k ) = initvalue;
            end
        end
    end
    color = jet( length );
    if strcmp(action,"initialization")
        figure( "Name", "3D Game of Life", "CloseRequestFcn", @closeSim );
        % Initializes the 3D plot
        axis equal ;
        xlabel( 'X-axis' );
        ylabel( 'Y-axis' );
        zlabel( 'Z-axis' );
        title( '3D Game of Life Visualization' );
        grid on ;
        view( 3 )
    end
    %==========================================================================
    % Information for all buttons
    yInitPos=0.90;
    xPos=0.85;
    btnLen=0.10;
    btnWid=0.10;
    % Spacing between the button and the next command's label
    spacing=0.05;
    %==========================================================================
    % The START button
    ctrlRelPos=1;
    yPos=0.90-(ctrlRelPos-1)*(btnWid+spacing);
    labelStr='Start';
    callback=@startSim;

    % Generic button information
    ctrlPos=[xPos yPos-spacing btnLen btnWid];
    startHndl=uicontrol( ...
        'Style','pushbutton', ...
        'BackgroundColor',[0.23 0.23 0.25 1], ...
        'ForegroundColor','white', ...
        'Units','normalized', ...
        'Position',ctrlPos, ...
        'Tooltip', sprintf("Starts/stops the simulation."),...
        'String',labelStr, ...
        'Interruptible','on', ...
        'Callback',callback);
    %==========================================================================
    % The RESET button
    ctrlRelPos=2;
    yPos=0.90-(ctrlRelPos-1)*(btnWid+spacing);
    labelStr='Reset';
    callback=@resetSim;

    % Generic button information
    ctrlPos=[xPos yPos-spacing btnLen btnWid];
    resetHndl=uicontrol( ...
        'Style','pushbutton', ...
        'BackgroundColor',[0.23 0.23 0.25 1], ...
        'ForegroundColor','white', ...
        'Units','normalized', ...
        'Position',ctrlPos, ...
        'Tooltip', sprintf("Resets the simulation to its initial condition - keeps the rules."),...
        'String',labelStr, ...
        'Interruptible','on', ...
        'Callback',callback);
    %==========================================================================
    % The STEP button
    ctrlRelPos=3;
    yPos=0.90-(ctrlRelPos-1)*(btnWid+spacing);
    labelStr='Step';
    callback=@stepSim;

    % Generic button information
    ctrlPos=[xPos yPos-spacing btnLen btnWid];
    stepHndl=uicontrol( ...
        'Style','pushbutton', ...
        'BackgroundColor',[0.23 0.23 0.25 1], ...
        'ForegroundColor','white', ...
        'Units','normalized', ...
        'Position',ctrlPos, ...
        'String',labelStr, ...
        'Tooltip', sprintf("Advances the simulation by 1 generation."),...
        'Interruptible','on', ...
        'Callback',callback);
    %==========================================================================
    % The SURVIVAL text label
    ctrlRelPos=4.5;
    yPos=0.90-(ctrlRelPos-1)*(btnWid+(spacing/12));
    labelStr='Survival rule:';

    % Generic button information
    ctrlPos=[xPos yPos-spacing btnLen btnWid/3];
    survivaltxtHndl=uicontrol( ...
        'Style','text', ...
        'BackgroundColor',[0.9, 0.9, 0.9, 1], ...
        'ForegroundColor','black', ...
        'FontUnits','normalized', ...
        'FontSize', 0.75,...
        'HorizontalAlignment','left', ...
        'Units','normalized', ...
        'Position', ctrlPos, ...
        'Tooltip', sprintf("This ruleset specifies the number of live\nneighboring cells that the checked cell \nneeds to have to survive the next generation.\nFew examples:\n '4 5' - the cell needs 4 or 5 alive neighbours to survive"),...
        'String',labelStr, ...
        'Interruptible','on');
    %==========================================================================
    % The SURVIVAL text field
    ctrlRelPos=4.85;
    yPos=0.90-(ctrlRelPos-1)*(btnWid+(spacing/12));
    labelStr=num2str(survival);

    % Generic button information
    ctrlPos=[xPos yPos-spacing btnLen btnWid/3];
    survivalHndl=uicontrol( ...
        'Style','edit', ...
        'BackgroundColor',[0.23 0.23 0.25 1], ...
        'ForegroundColor','white', ...
        'HorizontalAlignment','left', ...
        'Units','normalized', ...
        'Position', ctrlPos, ...
        'String',labelStr, ...
        'Interruptible','on');
    %==========================================================================
    % The BIRTH text label
    ctrlRelPos=5.5;
    yPos=0.90-(ctrlRelPos-1)*(btnWid+(spacing/12));
    labelStr='Birth rule:';

    % Generic button information
    ctrlPos=[xPos yPos-spacing btnLen btnWid/3];
    birthtxtHndl=uicontrol( ...
        'Style','text', ...
        'BackgroundColor',[0.9, 0.9, 0.9, 1], ...
        'ForegroundColor','black', ...
        'FontUnits','normalized', ...
        'FontSize', 0.75,...
        'HorizontalAlignment','left', ...
        'Units','normalized', ...
        'Position', ctrlPos, ...
        'Tooltip', sprintf("This ruleset specifies the number of live\nneighboring cells that the checked cell \nneeds to have to become alive.\nFew examples:\n '3 4' - the cell needs 3 or 4 alive neighbours to become a live cell"), ...
        'String',labelStr, ...
        'Interruptible','on');
    %==========================================================================
    % The BIRTH text field
    ctrlRelPos=5.85;
    yPos=0.90-(ctrlRelPos-1)*(btnWid+(spacing/12));
    labelStr=num2str(birth);

    % Generic button information
    ctrlPos=[xPos yPos-spacing btnLen btnWid/3];
    birthHndl=uicontrol( ...
        'Style','edit', ...
        'BackgroundColor',[0.23 0.23 0.25 1], ...
        'ForegroundColor','white', ...
        'HorizontalAlignment','left', ...
        'Units','normalized', ...
        'Position', ctrlPos, ...
        'String',labelStr, ...
        'Interruptible','on');
    %==========================================================================
    % The NEIGHBORHOOD text label
    ctrlRelPos=6.5;
    yPos=0.90-(ctrlRelPos-1)*(btnWid+(spacing/12));
    labelStr='Neighborhood:';

    % Generic button information
    ctrlPos=[xPos yPos-spacing btnLen btnWid/3];
    neighborhoodtxtHndl=uicontrol( ...
        'Style','text', ...
        'BackgroundColor',[0.9, 0.9, 0.9, 1], ...
        'ForegroundColor','black', ...
        'FontUnits','normalized', ...
        'FontSize', 0.75,...
        'HorizontalAlignment','left', ...
        'Units','normalized', ...
        'Position', ctrlPos, ...
        'Tooltip', sprintf("This is the shape of the checked neighborhood:\nvon Neumann - 6 cells\nradial - 18 cells\nMoore - 26 cells"), ...
        'String',labelStr, ...
        'Interruptible','on');
    %==========================================================================
    % The NEIGHBORHOOD popupmenu
    ctrlRelPos=6.85;
    yPos=0.90-(ctrlRelPos-1)*(btnWid+(spacing/12));
    neighborhoodStr={'von Neumann','radial','Moore'};

    % Generic button information
    ctrlPos=[xPos yPos-spacing btnLen btnWid/3];
    neighborhoodHndl=uicontrol( ...
        'Style','popupmenu', ...
        'BackgroundColor',[0.23 0.23 0.25 1], ...
        'ForegroundColor','white', ...
        'FontUnits','normalized', ...
        'FontSize', 0.5,...
        'HorizontalAlignment','left', ...
        'Units','normalized', ...
        'Position', ctrlPos, ...
        'String',neighborhoodStr, ...
        'Value',neighborhood,...
        'Interruptible','on');
    %==========================================================================
    % The APPLY button
    ctrlRelPos=6;
    yPos=0.90-(ctrlRelPos-1)*(btnWid+spacing);
    labelStr='Apply rules';
    callback=@(src, event)applyRules(src, event, survivalHndl.String, birthHndl.String, neighborhoodHndl.Value );

    % Generic button information
    ctrlPos=[xPos yPos-spacing btnLen btnWid];
    applyHndl=uicontrol( ...
        'Style','pushbutton', ...
        'BackgroundColor',[0.23 0.23 0.25 1], ...
        'ForegroundColor','white', ...
        'Units','normalized', ...
        'Position',ctrlPos, ...
        'String',labelStr, ...
        'Interruptible','on', ...
        'Callback',callback);
    %==========================================================================
    % Exporting data to guidata
    data.isStarted = 0;
    data.cells = cells;
    if strcmp(action,"initialization")
        set(gcf, "UserData", struct('Survival', num2str(survival),'SurvivalRule', survival, 'Birth', num2str(birth), 'BirthRule', birth, 'Neighborhood', neighborhood));
    end
    data.color = color;
    data.startHndl = startHndl;
    guidata(gcf, data);
end
data = guidata(gcf);
cells = data.cells;
survival = gcf().UserData.SurvivalRule;
birth = gcf().UserData.BirthRule;
neighborhood = gcf().UserData.Neighborhood;
color = data.color;
cell_voxels = zeros( length, length, length );
cla(gcf);
for i = 1:size( cells, 1 )
    for j = 1:size( cells, 2 )
        for k = 1:size( cells, 3 )
            [x,y,z] = cube( i, j, k, radius);
            hold on ;
            cell_voxels( i, j, k ) = surface( x, y, z, 'FaceColor', color( k, : ) );
            hold off ;
        end
    end
end
for i = 1:size( cells, 1 )
    for j = 1:size( cells, 2 )
        for k = 1:size( cells, 3 )
            if cells( i, j, k )==1
                set( cell_voxels( i, j, k ), 'FaceAlpha', 1.0 );
                set( cell_voxels( i, j, k ), 'EdgeColor', 'flat' );
            else
                set( cell_voxels( i, j, k ), 'FaceAlpha', 0.0 );
                set( cell_voxels( i, j, k ), 'EdgeColor', 'none' );
            end
        end
    end
end
if strcmp(action,"start") | strcmp(action,"step")
    set(data.startHndl, "String", "Stop");
    set(data.startHndl, "Callback", @stopSim);
    try
    while data.isStarted == 1
        new_cells = zeros( length, length, length );
        for i = 1:size( cells, 1 )
            for j = 1:size( cells, 2 )
                for k = 1:size( cells, 3 )
                    % Update the cells based on the Game of Life rules (scaled up to 3D)
                    neighbours = 0;
                    if (neighborhood>=0)
                        % Von Neumann neighborhood check
                        neighbours = neighbours + getValue( cells, i + 1, j, k, 0 );
                        neighbours = neighbours + getValue( cells, i - 1, j, k, 0 );
                        neighbours = neighbours + getValue( cells, i, j + 1, k, 0 );
                        neighbours = neighbours + getValue( cells, i, j - 1, k, 0 );
                        neighbours = neighbours + getValue( cells, i, j, k + 1, 0 );
                        neighbours = neighbours + getValue( cells, i, j, k - 1, 0 );
                    end
                    if (neighborhood>=1)
                        % Radial neighborhood check
                        neighbours = neighbours + getValue( cells, i + 1, j + 1, k, 0 );
                        neighbours = neighbours + getValue( cells, i - 1, j + 1, k, 0 );
                        neighbours = neighbours + getValue( cells, i + 1, j - 1, k, 0 );
                        neighbours = neighbours + getValue( cells, i - 1, j - 1, k, 0 );
                        neighbours = neighbours + getValue( cells, i, j + 1, k + 1, 0 );
                        neighbours = neighbours + getValue( cells, i, j - 1, k + 1, 0 );
                        neighbours = neighbours + getValue( cells, i, j + 1, k - 1, 0 );
                        neighbours = neighbours + getValue( cells, i, j - 1, k - 1, 0 );
                        neighbours = neighbours + getValue( cells, i + 1, j, k + 1, 0 );
                        neighbours = neighbours + getValue( cells, i + 1, j, k - 1, 0 );
                        neighbours = neighbours + getValue( cells, i - 1, j, k + 1, 0 );
                        neighbours = neighbours + getValue( cells, i - 1, j, k - 1, 0 );
                    end
                    if (neighborhood>=2)
                        % Moore neighborhood check
                        neighbours = neighbours + getValue( cells, i + 1, j + 1, k + 1, 0 );
                        neighbours = neighbours + getValue( cells, i + 1, j + 1, k - 1, 0 );
                        neighbours = neighbours + getValue( cells, i + 1, j - 1, k + 1, 0 );
                        neighbours = neighbours + getValue( cells, i + 1, j - 1, k - 1, 0 );
                        neighbours = neighbours + getValue( cells, i - 1, j + 1, k + 1, 0 );
                        neighbours = neighbours + getValue( cells, i - 1, j + 1, k - 1, 0 );
                        neighbours = neighbours + getValue( cells, i - 1, j - 1, k + 1, 0 );
                        neighbours = neighbours + getValue( cells, i - 1, j - 1, k - 1, 0 );
                    end
                    new_cells(i,j,k) = 0; % Cell dies
                    for s = 1:size( survival, 2 )
                        if (neighbours==survival( s ))
                            new_cells(i,j,k) = cells(i,j,k); % Cell lives
                        end
                    end
                    for b = 1:size( birth, 2 )
                        if (neighbours==birth( b ))
                            new_cells(i,j,k) = 1; % New cell is born
                        end
                    end
                end
            end
        end
        cells = new_cells;
        % Displaying cells
        for i = 1:size( cells, 1 )
            for j = 1:size( cells, 2 )
                for k = 1:size( cells, 3 )
                    if cells( i, j, k )==1
                        set( cell_voxels( i, j, k ), 'FaceAlpha', 1.0 );
                        set( cell_voxels( i, j, k ), 'EdgeColor', 'flat' );
                    else
                        set( cell_voxels( i, j, k ), 'FaceAlpha', 0.0 );
                        set( cell_voxels( i, j, k ), 'EdgeColor', 'none' );
                    end
                end
            end
        end
        drawnow
        if strcmp(action,"step")
            stopSim(gcf);
        end
        data = guidata(gcf);
        % Exporting data to guidata
        data.cells = cells;
        guidata(gcf, data);
    end
    catch
        return;
    end
    return;
end
if strcmp(action,"stop") | strcmp(action,"close")
    set(data.startHndl, "String", "Start");
    set(data.startHndl, "Callback", @startSim);
    return;
end
end

% Cube vertices that needs to be drawn
% The cube's center is on the [posX, posY, posZ] point and the other points
% are drawn by the value of the width apart
function [x,y,z] = cube(posX,posY,posZ,width)
x = [ posX + width, posX + width, posX + width, posX + width, posX + width; posX + width, posX + width, posX - width, posX - width, posX + width; posX + width, posX + width, posX - width, posX - width, posX + width; posX + width, posX + width, posX + width, posX + width, posX + width ];
y = [ posY + width, posY - width, posY - width, posY + width, posY + width; posY + width, posY - width, posY - width, posY + width, posY + width; posY + width, posY - width, posY - width, posY + width, posY + width; posY + width, posY - width, posY - width, posY + width, posY + width ];
z = [ posZ - width, posZ - width, posZ - width, posZ - width, posZ - width; posZ - width, posZ - width, posZ - width, posZ - width, posZ - width; posZ + width, posZ + width, posZ + width, posZ + width, posZ + width; posZ + width, posZ + width, posZ + width, posZ + width, posZ + width ];
end

% "Safe" array indexing
function value = getValue(array,x,y,z,default_val)
try
    value = array( x, y, z );
catch
    value = default_val;
end
end

function startSim(src, ~)
data = guidata(gcf);
data.isStarted = 1;
guidata(src,data);
gol3D("start");
end

function stepSim(src, ~)
data = guidata(gcf);
data.isStarted = 1;
guidata(src,data);
gol3D("step");
end

function stopSim(src, ~)
data = guidata(gcf);
data.isStarted = 0;
guidata(src,data);
gol3D("stop");
end

function closeSim(src, ~)
data = guidata(gcf);
data.isStarted = 0;
guidata(src,data);
gol3D("stop");
delete(src);
end

function resetSim(src, ~)
data = guidata(gcf);
data.isStarted = 0;
guidata(src,data);
gol3D("reset");
uialert(gcf, "The simulation has been reset!", "Simulation reset", "Modal",true, "Icon", "success");
end

function applyRules(src, event, survival, birth, neighborhood)
stopSim(src);
survivalrule = str2num(survival, "Evaluation", "restricted");
if isempty(survivalrule)
    uialert(gcf, ["The survival rule is invalid!", "Valid rule example: 1 2 4"], "Rule error", "Modal",true, "Icon", "error");
    return;
end
birthrule = str2num(birth, "Evaluation", "restricted");
if isempty(birthrule)
    uialert(gcf, ['The birth rule is invalid!', 'Valid rule example: 2 4'], "Rule error", "Modal",true, "Icon", "error");
    return;
end
set(gcf, "UserData", struct('Survival', survival,'SurvivalRule', survivalrule, 'Birth', birth, 'BirthRule', birthrule, 'Neighborhood', neighborhood));
uialert(gcf, 'The survival and birth rule has been set.', "Rule is set", "Modal",true, "Icon", "success");
end