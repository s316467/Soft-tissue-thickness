%COMPLETARE LE RIGHE PER LA VISUALIZZAZIONE DEL MODELLO. A PARTIRE DALL'STL OTTENERE UNA DEPTH MAP CHE SIMULI L'ANDAMENTO DI UNA SUPERFICIE IN FORMA z=f(x,y).
%Importiamo gli stl creati in meshlab: usiamo la funzione stlread.
%Completare la funzione.
path1="hmr/hmr_hard_tissue/";
path2="hmr/hmr_soft_tissue/";
% hard_tissue={"hmr_001_mesh_hard.stl", "hmr_002_mesh.stl" , "hmr_003_mesh.stl","hmr_004_rv_mesh.stl", "hmr_005_mesh.stl", "hmr_006_mesh.stl", "hmr_007_mesh.stl", "hmr_008_mesh.stl", "hmr_019_mesh.stl", "hmr_027_mesh.stl"};
% soft_tissue = {"hmr_001_mesh.stl", "hmr_002_mesh.stl" , "hmr_003_mesh.stl","hmr_004_mesh.stl", "hmr_005_mesh.stl", "hmr_006_mesh.stl", "hmr_007_mesh.stl", "hmr_008_mesh.stl", "hmr_019_mesh.stl", "hmr_027_mesh.stl"};
% hard_tissue ={"hmr_005_mesh_2.stl", "hmr_006_mesh_3.stl"}
% soft_tissue={"hmr_001.stl", "hmr_002.stl", "hmr_003.stl", "hmr_004.stl", "hmr_005.stl", "hmr_006.stl", "hmr_007.stl", "hmr_008.stl", "hmr_019.stl", "hmr_027.stl"}
% hard_tissue ={"hmr_001.stl", "hmr_002.stl", "hmr_003.stl", "hmr_004.stl", "hmr_005.stl", "hmr_006.stl", "hmr_007.stl", "hmr_008.stl", "hmr_019.stl", "hmr_027.stl"}
hard_tissue ={"hmr_001.stl"}
soft_tissue ={"hmr_001.stl"}
for i=1:2

    bone=stlread(path1+hard_tissue{i});
    soft=stlread(path2+soft_tissue{i});
    %V= elenco delle coordinate dei vertici. F=elenco dei vertici connessi
    %(ogni riga corrisponde a un triangolo).
    Vb=bone.Points;
    Fb=bone.ConnectivityList;
    Vs=soft.Points;
    Fs=soft.ConnectivityList;
    %Apriamo gli stl in una figura per vedere come sono orientati: per farlo
    %usiamo la funzione patch.
    % figure('color',[1 1 1])
    % view(3)
    % patch('vertices',Vs,'faces',Fb,'edgecolor','none', 'facecolor',[0.8 0.8 0.8],'facelighting','gouraud')
    % light
    % grid on
    % axis on
    % axis equal 
    % xlabel('X'),ylabel('Y'),zlabel('Z'), hold on
    % patch('vertices',Vs,'faces',Fs,'edgecolor','none', 'facecolor',[0.8 0.8 0.8],'facelighting','gouraud')
    % Il modello deve essere orientato  a "faccia in su": se non lo è bisogna
    % ruotarlo. Definire l'angolo di rotazione t. Applicare la matrice di
    % rotazione alla matrice delle coordinate.
    
    t=90;
    Rx = [1 0 0; 0 cos(t) -sin(t); 0 sin(t) cos(t)]
    Vbrot=Vb*Rx;
    Vsrot=Vs*Rx;
    
    %%% visualizza bone
    f1=figure('color',[1 1 1])
    view(3)
    patch('vertices',Vbrot,'faces',Fb,'edgecolor','none', 'facecolor',[0.8 0.8 0.8],'facelighting','gouraud')
    light
    grid on
    axis on
    axis equal 
    xlabel('X'),ylabel('Y'),zlabel('Z'), hold on
    saveas(f1, sprintf('hmr/mesh/bone/%s.png', hard_tissue{i}));


    %%%%% visualizza soft
    
    f2=figure('color',[1 1 1])
    view(3)
    patch('vertices',Vsrot,'faces',Fs,'edgecolor','none', 'facecolor',[0.8 0.8 0.8],'facelighting','gouraud')
    light
    grid on
    axis on
    axis equal 
    xlabel('X'),ylabel('Y'),zlabel('Z'), hold on
    saveas(f2, sprintf('hmr/mesh/soft_3d/%s.png', soft_tissue{i}));
    % 
    % Per visualizzare il modello in forma z=f(x,y) richiamiamo la funzione
    % demonstration_fun, la quale crea una superficie a griglia quadrata a partire dalla
    % mesh triangolare. Demonstration_fun chiede in input la matrice dei
    % vertici e quella delle facce dei triangoli. Completare la funzione.
    
    % 
    [Xb,Yb,Zb]=demonstration_fun(Vbrot,Fb);
    [Xs,Ys,Zs]=demonstration_fun(Vsrot,Fs);
    % Visualizziamo la superficie: utilizziamo la funzione surf. Completare la
    % funzione.
    % figure; surf(Zb), hold on
    %surf(Zs), hold off
    f3=figure;surf(Zb)
    saveas(f3, sprintf('hmr/mesh/hard/hard_mesh_%s.png', hard_tissue{i}));
    f4=figure;surf(Zs)
    saveas(f4, sprintf('hmr/mesh/soft/soft_mesh_%s.png', soft_tissue{i}));
    save(sprintf('hmr/mat_mesh/2_%s.mat', hard_tissue{i}));
end 
    
    

