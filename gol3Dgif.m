 width = 0.5;
length = 31;
% Initial configuration
%===============================================
centerwidth = 1; %length/4;
initvalue = 1; %randi([0 1]);
% Rules
%===============================================
% 0 - von Neumann neighborhood (6 cells checked)
% 1 - radial neighborhood (18 cells checked)
% 3 - Moore neighborhood (26 cells checked)
neighborhood = 2;
survival = [ 3 4 5 6 7 8 ];
birth = [ 4 6 8 9 10 ];
% GIF
%===============================================
pathtogif = 'gifs/S3-8B468-10M.gif'
%===============================================
cells = zeros( length, length, length );
for i = -round( centerwidth ):round( centerwidth )
    for j = -round( centerwidth ):round( centerwidth )
        for k = -round( centerwidth ):round( centerwidth )
            cells( round( length / 2 ) + i, round( length / 2 ) + j, round( length / 2 ) + k ) = initvalue;
        end
    end
end
color = jet( length );
fig = figure( "Name", "3D Game of Life" );
% Initialize the 3D plot
axis equal ;
xlabel( 'X-axis' );
ylabel( 'Y-axis' );
zlabel( 'Z-axis' );
title( '3D Game of Life Visualization' );
grid on ;
view( 3 )
cell_voxels = zeros( length, length, length );
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
for t = 1:30
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
    exportgraphics(fig, pathtogif, "Append", true);
end
function [x,y,z] = cube(posx,posy,posz,width)
    x = [ posx + width, posx + width, posx + width, posx + width, posx + width; posx + width, posx + width, posx - width, posx - width, posx + width; posx + width, posx + width, posx - width, posx - width, posx + width; posx + width, posx + width, posx + width, posx + width, posx + width ];
    y = [ posy + width, posy - width, posy - width, posy + width, posy + width; posy + width, posy - width, posy - width, posy + width, posy + width; posy + width, posy - width, posy - width, posy + width, posy + width; posy + width, posy - width, posy - width, posy + width, posy + width ];
    z = [ posz - width, posz - width, posz - width, posz - width, posz - width; posz - width, posz - width, posz - width, posz - width, posz - width; posz + width, posz + width, posz + width, posz + width, posz + width; posz + width, posz + width, posz + width, posz + width, posz + width ];
end
function value = get(array,x,y,z,default_val)
    try
        value = array( x, y, z );
    catch
        value = default_val;
    end
end

