% action:
% "stop" - Simulation is stopped
% "start" - Simulation is playing
% "initialization" - Initializes the simulation (plot, cells, ui controls)
% "reset" - Resets the simulation (clears the cells array and clears the plot)
function gol3D(action)
if nargin<1
    action = "initialization";
end
% Width of the voxels
width = 0.5;
% The simulated space's dimension (length x length x length cube)
length = 11;
if strcmp(action,"initialization") | strcmp(action,"reset")
    % The initialized center's width
    centerwidth = 1; %length/4;
    % The initialized
    initvalue = 1; %randi([0 1]);
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
        figure( "Name", "3D Game of Life" );
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
    callback=@StartSim;

    % Generic button information
    ctrlPos=[xPos yPos-spacing btnLen btnWid];
    startHndl=uicontrol( ...
        'Style','pushbutton', ...
        'BackgroundColor','black', ...
        'ForegroundColor','white', ...
        'Units','normalized', ...
        'Position',ctrlPos, ...
        'String',labelStr, ...
        'Interruptible','on', ...
        'Callback',callback);
    %==========================================================================
    % The RESET button
    ctrlRelPos=2;
    yPos=0.90-(ctrlRelPos-1)*(btnWid+spacing);
    labelStr='Reset';
    callback=@ResetSim;

    % Generic button information
    ctrlPos=[xPos yPos-spacing btnLen btnWid];
    resetHndl=uicontrol( ...
        'Style','pushbutton', ...
        'BackgroundColor','black', ...
        'ForegroundColor','white', ...
        'Units','normalized', ...
        'Position',ctrlPos, ...
        'String',labelStr, ...
        'Interruptible','on', ...
        'Callback',callback);
    %==========================================================================
    % The SURVIVAL text label
    ctrlRelPos=3;
    yPos=0.90-(ctrlRelPos-1)*(btnWid+(spacing/3));
    labelStr='Survival rule:';
    callback=@ResetSim;

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
        'String',labelStr, ...
        'Interruptible','on', ...
        'Callback',callback);
    %==========================================================================
    % The SURVIVAL text field
    ctrlRelPos=4;
    yPos=0.90-(ctrlRelPos-1)*((0.875*btnWid)+(spacing/12));
    labelStr='4';
    callback=@ResetSim;

    % Generic button information
    ctrlPos=[xPos yPos-spacing btnLen btnWid/3];
    survivalHndl=uicontrol( ...
        'Style','edit', ...
        'BackgroundColor','black', ...
        'ForegroundColor','white', ...
        'HorizontalAlignment','left', ...
        'Units','normalized', ...
        'Position', ctrlPos, ...
        'String',labelStr, ...
        'Interruptible','on', ...
        'Callback',callback);
    %==========================================================================
    % The BIRTH text label
    ctrlRelPos=5;
    yPos=0.90-(ctrlRelPos-1)*(btnWid+(spacing/3));
    labelStr='Birth rule:';
    callback=@ResetSim;

    % Generic button information
    ctrlPos=[xPos yPos+spacing btnLen btnWid/3];
    survivaltxtHndl=uicontrol( ...
        'Style','text', ...
        'BackgroundColor',[0.9, 0.9, 0.9, 1], ...
        'ForegroundColor','black', ...
        'FontUnits','normalized', ...
        'FontSize', 0.75,...
        'HorizontalAlignment','left', ...
        'Units','normalized', ...
        'Position', ctrlPos, ...
        'String',labelStr, ...
        'Interruptible','on', ...
        'Callback',callback);
    %==========================================================================
    % The BIRTH text field
    ctrlRelPos=6;
    yPos=0.90-(ctrlRelPos-1)*((0.975*btnWid)+(spacing/12));
    labelStr='3,4';
    callback=@ResetSim;

    % Generic button information
    ctrlPos=[xPos yPos+spacing btnLen btnWid/3];
    survivalHndl=uicontrol( ...
        'Style','edit', ...
        'BackgroundColor','black', ...
        'ForegroundColor','white', ...
        'HorizontalAlignment','left', ...
        'Units','normalized', ...
        'Position', ctrlPos, ...
        'String',labelStr, ...
        'Interruptible','on', ...
        'Callback',callback);
    %==========================================================================
    % The NEIGHBORHOOD text label
    ctrlRelPos=6.15;
    yPos=0.90-(ctrlRelPos-1)*(btnWid+(spacing/3));
    labelStr='Neighborhood rule:';
    callback=@ResetSim;

    % Generic button information
    ctrlPos=[xPos yPos+spacing btnLen btnWid/3];
    survivaltxtHndl=uicontrol( ...
        'Style','text', ...
        'BackgroundColor',[0.9, 0.9, 0.9, 1], ...
        'ForegroundColor','black', ...
        'FontUnits','normalized', ...
        'FontSize', 0.75,...
        'HorizontalAlignment','left', ...
        'Units','normalized', ...
        'Position', ctrlPos, ...
        'String',labelStr, ...
        'Interruptible','on', ...
        'Callback',callback);
    %==========================================================================
    % The NEIGHBORHOOD popupmenu
    ctrlRelPos=7.35;
    yPos=0.90-(ctrlRelPos-1)*((0.975*btnWid)+(spacing/12));
    neighborhoodStr={'von Neumann','radial','Moore'};
    callback=@ResetSim;

    % Generic button information
    ctrlPos=[xPos yPos+spacing btnLen btnWid/3];
    survivalHndl=uicontrol( ...
        'Style','popupmenu', ...
        'BackgroundColor','black', ...
        'ForegroundColor','white', ...
        'FontUnits','normalized', ...
        'FontSize', 0.5,...
        'HorizontalAlignment','left', ...
        'Units','normalized', ...
        'Position', ctrlPos, ...
        'String',neighborhoodStr, ...
        'Interruptible','on', ...
        'Callback',callback);
    %==========================================================================
    % The APPLY button
    ctrlRelPos=5.5;
    yPos=0.90-(ctrlRelPos-1)*(btnWid+spacing);
    labelStr='Apply rules';
    callback=@ResetSim;

    % Generic button information
    ctrlPos=[xPos yPos-spacing btnLen btnWid];
    resetHndl=uicontrol( ...
        'Style','pushbutton', ...
        'BackgroundColor','black', ...
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
    data.color = color;
    data.startHndl = startHndl;
    guidata(gcf, data);
end
data = guidata(gcf);
cells = data.cells;
color = data.color;
cell_voxels = zeros( length, length, length );
% 0 - Moore neighborhood (6 cells checked)
% 1 - radial neighborhood
% 2 - von Neumann neighborhood
neighborhood = 2;
% Rules
survival = [ 3 4 5 6 7 8 ];
birth = [ 4 6 8 9 10 ];
cla(gcf);
for i = 1:size( cells, 1 )
    for j = 1:size( cells, 2 )
        for k = 1:size( cells, 3 )
            [x,y,z] = cube( i, j, k, width); %0.5 - (k * 0.01) );
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
if strcmp(action,"start")
    set(data.startHndl, "String", "Stop");
    set(data.startHndl, "Callback", @StopSim);
    while data.isStarted == 1
        new_cells = zeros( length, length, length );
        for i = 1:size( cells, 1 )
            for j = 1:size( cells, 2 )
                for k = 1:size( cells, 3 )
                    % Update the cells based on the Game of Life rules (scaled up to 3D)
                    neighbours = 0;
                    if (neighborhood>=0)
                        neighbours = neighbours + get( cells, i + 1, j, k, 0 );
                        neighbours = neighbours + get( cells, i - 1, j, k, 0 );
                        neighbours = neighbours + get( cells, i, j + 1, k, 0 );
                        neighbours = neighbours + get( cells, i, j - 1, k, 0 );
                        neighbours = neighbours + get( cells, i, j, k + 1, 0 );
                        neighbours = neighbours + get( cells, i, j, k - 1, 0 );
                    end
                    if (neighborhood>=1)
                        neighbours = neighbours + get( cells, i + 1, j + 1, k, 0 );
                        neighbours = neighbours + get( cells, i - 1, j + 1, k, 0 );
                        neighbours = neighbours + get( cells, i + 1, j - 1, k, 0 );
                        neighbours = neighbours + get( cells, i - 1, j - 1, k, 0 );
                        neighbours = neighbours + get( cells, i, j + 1, k + 1, 0 );
                        neighbours = neighbours + get( cells, i, j - 1, k + 1, 0 );
                        neighbours = neighbours + get( cells, i, j + 1, k - 1, 0 );
                        neighbours = neighbours + get( cells, i, j - 1, k - 1, 0 );
                        neighbours = neighbours + get( cells, i + 1, j, k + 1, 0 );
                        neighbours = neighbours + get( cells, i + 1, j, k - 1, 0 );
                        neighbours = neighbours + get( cells, i - 1, j, k + 1, 0 );
                        neighbours = neighbours + get( cells, i - 1, j, k - 1, 0 );
                    end
                    if (neighborhood>=2)
                        neighbours = neighbours + get( cells, i + 1, j + 1, k + 1, 0 );
                        neighbours = neighbours + get( cells, i + 1, j + 1, k - 1, 0 );
                        neighbours = neighbours + get( cells, i + 1, j - 1, k + 1, 0 );
                        neighbours = neighbours + get( cells, i + 1, j - 1, k - 1, 0 );
                        neighbours = neighbours + get( cells, i - 1, j + 1, k + 1, 0 );
                        neighbours = neighbours + get( cells, i - 1, j + 1, k - 1, 0 );
                        neighbours = neighbours + get( cells, i - 1, j - 1, k + 1, 0 );
                        neighbours = neighbours + get( cells, i - 1, j - 1, k - 1, 0 );
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
        % For exporting the figure frames into gifs
        %exportgraphics(fig, 'S3-8B468-10M.gif', "Append", true);
        %pause( 0.01 );
        data = guidata(gcf);
        % Exporting data to guidata
        data.cells = cells;
        guidata(gcf, data);
    end
    return;
end
if strcmp(action,"stop")
    set(data.startHndl, "String", "Start");
    set(data.startHndl, "Callback", @StartSim);
    return;
end
end

% Cube points that needs to be drawn
function [x,y,z] = cube(posx,posy,posz,width)
x = [ posx + width, posx + width, posx + width, posx + width, posx + width; posx + width, posx + width, posx - width, posx - width, posx + width; posx + width, posx + width, posx - width, posx - width, posx + width; posx + width, posx + width, posx + width, posx + width, posx + width ];
y = [ posy + width, posy - width, posy - width, posy + width, posy + width; posy + width, posy - width, posy - width, posy + width, posy + width; posy + width, posy - width, posy - width, posy + width, posy + width; posy + width, posy - width, posy - width, posy + width, posy + width ];
z = [ posz - width, posz - width, posz - width, posz - width, posz - width; posz - width, posz - width, posz - width, posz - width, posz - width; posz + width, posz + width, posz + width, posz + width, posz + width; posz + width, posz + width, posz + width, posz + width, posz + width ];
end

% "Safe" array indexing
function value = get(array,x,y,z,default_val)
try
    value = array( x, y, z );
catch
    value = default_val;
end
end

function StartSim(src,event)
data = guidata(gcf);
data.isStarted = 1;
guidata(src,data);
gol3D("start");
end

function StopSim(src,event)
data = guidata(gcf);
data.isStarted = 0;
guidata(src,data);
gol3D("stop");
end

function ResetSim(src,event)
data = guidata(gcf);
data.isStarted = 0;
guidata(src,data);
gol3D("reset");
end