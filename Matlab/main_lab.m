
close all;
clear all;
%COMPLETARE LE RIGHE PER LA VISUALIZZAZIONE DEL MODELLO. A PARTIRE DALL'STL OTTENERE UNA DEPTH MAP CHE SIMULI L'ANDAMENTO DI UNA SUPERFICIE IN FORMA z=f(x,y).
%Importiamo gli stl creati in meshlab: usiamo la funzione stlread.
%Completare la funzione.


soft_tissue={"hmr_001.stl", "hmr_002.stl", "hmr_003.stl", "hmr_004.stl", "hmr_005.stl", "hmr_006.stl", "hmr_007.stl", "hmr_008.stl", "hmr_019.stl", "hmr_027.stl","soggetto_007.stl","soggetto_008.stl","soggetto_009.stl"}
hard_tissue ={"hmr_001.stl", "hmr_002.stl", "hmr_003.stl", "hmr_004.stl", "hmr_005.stl", "hmr_006.stl", "hmr_007.stl", "hmr_008.stl", "hmr_019.stl", "hmr_027.stl", "soggetto_007.stl","soggetto_008.stl","soggetto_009.stl"}
% 

path1="hmr/hmr_hard_tissue/";
path2="hmr/hmr_soft_tissue/";



for i=1:numel(soft_tissue)
    
    bone=stlread(path1+hard_tissue{i});
    soft=stlread(path2+soft_tissue{i});
    patient= strsplit(hard_tissue{i},'.');
    patient=strsplit(patient{1},'_');
    patient=strcat(patient{1},'-',patient{2})
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
    titolo = sprintf('Hard - Paziente: %s', patient);
    title(titolo);
    patch('vertices',Vbrot,'faces',Fb,'edgecolor','none', 'facecolor',[0.8 0.8 0.8],'facelighting','gouraud')
    light
    grid on
    axis on
    axis equal 
    xlabel('X'),ylabel('Y'),zlabel('Z'), hold on
    mkdir(fullfile('hmr', 'mesh','bone'));
    saveas(f1, sprintf('hmr/mesh/bone/%s.png', hard_tissue{i}));


    %%%%% visualizza soft
    
    f2=figure('color',[1 1 1])
    view(3)
    titolo = sprintf('Soft - Paziente: %s', patient);
    title(titolo);
    patch('vertices',Vsrot,'faces',Fs,'edgecolor','none', 'facecolor',[0.8 0.8 0.8],'facelighting','gouraud')
    light
    grid on
    axis on
    axis equal 
    xlabel('X'),ylabel('Y'),zlabel('Z'), hold on
    mkdir(fullfile('hmr', 'mesh','soft_3d'));
    saveas(f2, sprintf('hmr/mesh/soft_3d/%s.png', soft_tissue{i}));
    % 
    % Per visualizzare il modello in forma z=f(x,y) richiamiamo la funzione
    % demonstration_fun, la quale crea una superficie a griglia quadrata a partire dalla
    % mesh triangolare. Demonstration_fun chiede in input la matrice dei
    % vertici e quella delle facce dei triangoli. Completare la funzione.
    
    % % 
    % % Creazione delle nuvole di punti dalle mesh
    % pc1 = pointCloud(Vbrot);
    % pc2 = pointCloud(Vsrot);
    % 
    % % Esegui la registrazione ICP per ottenere la trasformazione
    % [tform, ~, ~] = pcregistericp(pc2, pc1, 'Metric', 'pointToPoint');
    % 
    % % Applica la trasformazione alla seconda mesh
    % Vsrot = pctransform(pc2, tform).Location;

    [Xb,Yb,Zb]=demonstration_fun(Vbrot,Fb);
    [Xs,Ys,Zs]=demonstration_fun(Vsrot,Fs);
    % Visualizziamo la superficie: utilizziamo la funzione surf.
    f3=figure;surf(Xb,Yb,Zb)
    axis equal
    titolo = sprintf('Mesh hard - Paziente: %s', patient);
    title(titolo);
    mkdir(fullfile('hmr', 'mesh','hard'));
    saveas(f3, sprintf('hmr/mesh/hard/hard_mesh_%s.png', hard_tissue{i}));
    f4=figure;surf(Xs,Ys,Zs)
    axis equal
    titolo = sprintf('Mesh soft - Paziente: %s', patient);
    title(titolo);
    mkdir(fullfile('hmr', 'mesh','soft'));
    saveas(f4, sprintf('hmr/mesh/soft/soft_mesh_%s.png', soft_tissue{i}));
    save(sprintf('hmr/mat_mesh/%s.mat', hard_tissue{i}));

    f5=figure;
    
    surf(Xb, Yb, Zb,'FaceAlpha',0.5,DisplayName=patient);
    hold on;
    surf(Xs, Ys, Zs, 'FaceAlpha',0.5);
    titolo = sprintf('Mesh Dura e Molle Sovrapposte - Paziente: %s', patient);
    title(titolo);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    legend('Mesh Hard', 'Mesh Soft');
    view(0,90)
    axis equal;
    hold off;
    mkdir(fullfile('hmr', 'sovrapposizione'));
    saveas(f5, sprintf('hmr/sovrapposizione/hard_soft_%s.png', soft_tissue{i}));

    
    
end 
    
    

