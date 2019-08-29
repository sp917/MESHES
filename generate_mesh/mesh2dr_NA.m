% Mesh for North Atlantic Box set-up
% Modified for speed

 
  %Choose Resolution
  dx=1/2;    
  dy=1/2;   
  
  %Set domain size
  lon=0:dx:40;
  lat=30:dy:60;  
  
  nx=length(lon);
  ny=length(lat);
  nodnum=1:nx*ny;
  nodnum=reshape(nodnum,[ny, nx]);
  xcoord=zeros([ny, nx]);
  xnum=zeros([ny, nx]);
  ycoord=xcoord;
  ynum=zeros([ny, nx]);
  
  for n=1:nx
    ycoord(:,n)=lat';
    ynum(:,n)=(1:ny)';
  end
   
  for n=1:ny
    xcoord(n,:)=lon;
    xnum(n,:)=(1:nx);
  end
   
  xcoord=reshape(xcoord,[1,nx*ny]);
  ycoord=reshape(ycoord,[1,nx*ny]); 
  
  % Set a western coastline and remove all nodes lying on land
  %{
  i=1;
  while i < length(xcoord)
      if  ycoord(i) > 3*xcoord(i) + 30  %xcoord(i) < 10 - 0.1*(ycoord(i) - 45).^2 %ycoord(i) < 60 - 6*xcoord(i)
          ycoord(i) = NaN;
          xcoord(i) = NaN;
          i = i + 1;
      else
          i = i + 1;
      end
  end
  %}
  
  disp('creating initial mesh')

  tic
  
  tri1 = zeros((nx-1)*(ny-1),3);
  tri2 = zeros((nx-1)*(ny-1),3);
  
  nodnum1 = nodnum;
  nodnum2 = nodnum;
  nodnum3 = nodnum;
  nodnum5 = nodnum;
  
  nodnum1(end,:) = [];
  nodnum1(:,end) = [];
  
  nodnum2(1,:) = [];
  nodnum2(:,end) = [];
  
  nodnum3(end,:) = [];
  nodnum3(:,1) = [];
  
  nodnum5(1,:) = [];
  nodnum5(:,1) = [];
  
  tri1(:,1) = nodnum1(:) ;
  tri1(:,2) = nodnum2(:) ;
  tri1(:,3) = nodnum3(:) ;
  
  tri2(:,1) = nodnum2(:) ;
  tri2(:,2) = nodnum5(:) ;
  tri2(:,3) = nodnum3(:) ;
  
  tri = [tri1; tri2];
  tri = sortrows(tri);

  toc
  
  
  disp('removing nodes connected to only one triangle')
  tic
  TRI = tri(:); 
  while repeattest(TRI) == 0
    
    [C,ia,ic] = unique(TRI);
    a_counts = accumarray(ic,1);
    value_counts = [C, a_counts];
      
    for i = 1:size(value_counts,1)
      if value_counts(i,2)==1
        xcoord(i)
        ycoord(i)
        xcoord(i) = NaN;
        ycoord(i) = NaN;
        ai = find(tri==i);
        ai = mod(ai,size(tri,1));
        if ai==0 %this is when the edge node is at the end of the column in tri so the mod produces a 0
          ai = size(tri,1);
        end
        tri(ai,:) = [];
      end
    end
      
    TRI = tri(:);
  end
  toc
  
  
  disp('Set indices to 1 on boundary')
  tic
  n2d=(nx)*ny;
  nodes=zeros([4, n2d]); 
  nodes(1,:)=1:n2d;
  nodes(4,:)=zeros(size(ycoord)); 
  TRI = tri(:);
  %How many times does node i appear in TRI? That is, how many
  %triangles is node i attached to?
  [C,ia,ic] = unique(TRI);
  a_counts = accumarray(ic,1);
  value_counts = [C, a_counts];
  ai = find(a_counts<6);
  nodes(4,C(ai)) = 1;
  toc
  
  disp('Mesh distortion')
  tic
  amp=0.4;
  ampx=amp*dx;
  ampy=amp*dy;
  if 1<0
     ai=find(nodes(4,:)==0);
     xcoord(ai)=xcoord(ai)+(ampx*(-0.5+rand([1, length(ai)])));
     ycoord(ai)=ycoord(ai)+(ampy*(-0.5+rand([1, length(ai)]))); 
  end
  toc

  nodes(2,:)=xcoord;
  nodes(3,:)=ycoord; 
  
  disp('Relabel nodes') % so that they take numbers 1,2,3,...
  tic
  newnodnum = int64(isnan(xcoord));
  newlen = length(xcoord) - sum(newnodnum);
  newnodnum = 1-newnodnum;
  ai = find(newnodnum == 1);
  i=1;
  for a=ai
      newnodnum(a) = i;
      i = i+1;
  end
  n2d = newlen;
  toc


  disp('Remove NaN nodes from xcoords and ycoords')
  tic  
  i=1;
  while i <= length(xcoord)
      if isnan(xcoord(i))
          xcoord(i) = [];
          ycoord(i) = [];
          nodes(:,i) = [];
      else
          i = i+1;
      end
  end
  toc

  disp('Convert triangles to new node numbering')
  tic  
  tri = newnodnum(tri);
  nodes(1,:) = newnodnum(nodes(1,:));
  toc


  disp('creating file nod2d.out...') 
  tic
  fid = fopen('nod2d.out','w');
  fprintf(fid,'%8i \n',n2d);
  fprintf(fid,'%8i %8.4f %8.4f %8i\n',nodes); 
  fclose(fid);
  clear nodes       
  toc
         
  disp('creating file elem2d.out...')  
  tic
  fid=fopen('elem2d.out','w');
  fprintf(fid,'%8i \n', length(tri(:,1)));
  fprintf(fid,'%8i %8i %8i\n',tri');
  fclose(fid);
  toc

  %Define levels:
  zbar=[0 10 22 35 49 63 79 100 150 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600]; % 1800 2000 2200 2400 2600 2700 2800 3000 3200 3400 3600 3800 4000 4200 4400 4600]; 
  %zbar=[0:100:1500];
  nl=length(zbar);
  %define depths:
  %depth = -1500 + 100*sin(ycoord*pi/15.0);
  %depth=-500-3500*sin((ycoord-30)*pi/15.0);
  depth=-1600*ones(size(xcoord));
  %depth=-100*(xcoord <5.0) - 1600*(xcoord >= 5.0);
           
  disp('creating file aux3d.out...')  
  tic
  fid=fopen('aux3d.out', 'w');
  fprintf(fid,'%g\n', nl);
  fprintf(fid,'%g\n', zbar);
  fprintf(fid,'%7.1f\n', depth);
  fclose(fid);
  toc
