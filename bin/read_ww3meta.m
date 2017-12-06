function [lon,lat] = read_ww3meta(fname)

% -------------------------------------------------------------------------
%|                                                                        |
%|                    +----------------------------+                      |
%|                    | GRIDGEN          NOAA/NCEP |                      |
%|                    |                            |                      |
%|                    | Last Update :  23-Oct-2012 |                      |
%|                    +----------------------------+                      | 
%|                     Distributed with WAVEWATCH III                     |
%|                                                                        |
%|                 Copyright 2009 National Weather Service (NWS),         |
%|  National Oceanic and Atmospheric Administration.  All rights reserved.|
%|                                                                        |
%| DESCRIPTION                                                            |
%| Read the meta data file to obtain the lon and lat for a set of grids   |
%|                                                                        |
%| [lon,lat] = read_ww3meta(fname)                                        |
%|                                                                        |
%| INPUT                                                                  |
%|  fname       : Input meta data file name                               |
%|                                                                        |
%| OUTPUT                                                                 |
%|  lon,lat     : Longitude array (x) and lattitude array (y) of grid     |
% -------------------------------------------------------------------------

fid = fopen(fname,'r');

[messg,errno] = ferror(fid);

if (errno == 0)
   for i = 1:45
       tmp = fgetl(fid);
   end;
   
   % Grid Type
   tmp = fgetl(fid);
   gtype = sscanf(tmp,'%s',1);
   
   if (strmatch(gtype,'''RECT'''))
      Nx = fscanf(fid,'%d',1);
      Ny = fscanf(fid,'%d',1);
      dx = fscanf(fid,'%f',1);
      dy = fscanf(fid,'%f',1);
      scale = fscanf(fid,'%f',1);
      dx = dx/scale;
      dy = dy/scale;
      lons = fscanf(fid,'%f',1);
      lats = fscanf(fid,'%f',1);
      scale = fscanf(fid,'%f',1);

      lon1d = lons/scale + [0:(Nx-1)]*dx;
      lat1d = lats/scale + [0:(Ny-1)]*dy;

      [lon,lat] = meshgrid(lon1d,lat1d);

   else
 
      fprintf(1,' read_ww3meta has been designed for determining coordinates for rectlinwae grids only \n');
    
   end; 
      

else
   fprintf(1,'!!ERROR!!: %s \n',messg);
end;

fclose(fid);

return;
