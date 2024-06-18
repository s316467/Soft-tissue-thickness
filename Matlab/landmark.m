clear all
close all




landmarks_file = {"hmr_001_landmark.mat", "hmr_002_landmark.mat", "hmr_003_landmark.mat", "hmr_004_landmark.mat", "hmr_005_landmark.mat", "hmr_006_landmark.mat", "hmr_007_landmark.mat", "hmr_008_landmark.mat", "hmr_019_landmark.mat", "hmr_027_landmark.mat","soggetto_007_landmark.mat","soggetto_008_landmark.mat", "soggetto_009_landmark.mat"};

path3="hmr/landmark/";

for j=1:numel(landmarks_file)
    % 
    load(path3+landmarks_file{j})
    name=landmarks_file{j};
    patient = strsplit(name, '_');
    name_patient = patient{2}

    % per soft tissue
    f1=surf(Xs,Ys,Zs);
    title(['Soft Tissue -  ',patient{1},' ', name_patient]);
    hold on
    view(0,90)


    numberoflandmarks = 0;
    
    lm=table('Size',[28 4],'VariableTypes',{'string','double','double','double'});
        err=zeros(30,1);
        
        if exist('aldx','var')
            lm(1,1)={'aldx'};
            lm(1,2)={aldx.Position(1)};
            lm(1,3)={aldx.Position(2)};
            lm(1,4)={aldx.Position(3)};
            alaredx = [aldx.Position(1) aldx.Position(2) aldx.Position(3)];
            plot3(aldx.Position(1),aldx.Position(2),aldx.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(1)=1;
        end
        
           if exist('alsx','var')
            lm(2,1)={'alsx'};
            lm(2,2)={alsx.Position(1)};
            lm(2,3)={alsx.Position(2)};
            lm(2,4)={alsx.Position(3)};
            alaresx = [alsx.Position(1) alsx.Position(2) alsx.Position(3)];
            plot3(alsx.Position(1),alsx.Position(2),alsx.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(2)=1;
           end
        
           if exist('chdx','var')
            lm(3,1)={'chdx'};
            lm(3,2)={chdx.Position(1)};
            lm(3,3)={chdx.Position(2)};
            lm(3,4)={chdx.Position(3)};
            cheliondx = [chdx.Position(1) chdx.Position(2) chdx.Position(3)];
            plot3(chdx.Position(1),chdx.Position(2),chdx.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(3)=1;
           end
        
           if exist('chsx','var')
            lm(4,1)={'chsx'};
            lm(4,2)={chsx.Position(1)};
            lm(4,3)={chsx.Position(2)};
            lm(4,4)={chsx.Position(3)};
            chelionsx = [chsx.Position(1) chsx.Position(2) chsx.Position(3)];
            plot3(chsx.Position(1),chsx.Position(2),chsx.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(4)=1;
           end
           
           if exist('enr_soft','var')
            lm(5,1)={'enr_soft'};
            lm(5,2)={enr_soft.Position(1)};
            lm(5,3)={enr_soft.Position(2)};
            lm(5,4)={enr_soft.Position(3)};
            endocanthiondx_soft = [enr_soft.Position(1) enr_soft.Position(2) enr_soft.Position(3)];
            plot3(enr_soft.Position(1),enr_soft.Position(2),enr_soft.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(5)=1;
           end
        
           if exist('enl_soft','var')
            lm(6,1)={'enl_soft'};
            lm(6,2)={enl_soft.Position(1)};
            lm(6,3)={enl_soft.Position(2)};
            lm(6,4)={enl_soft.Position(3)};
            endocanthionsx_soft = [enl_soft.Position(1) enl_soft.Position(2) enl_soft.Position(3)];
            plot3(enl_soft.Position(1),enl_soft.Position(2),enl_soft.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(6)=1;
           end
           
            if exist('exr_soft','var')
            lm(7,1)={'exr_soft'};
            lm(7,2)={exr_soft.Position(1)};
            lm(7,3)={exr_soft.Position(2)};
            lm(7,4)={exr_soft.Position(3)};
            exocanthiondx_soft = [exr_soft.Position(1) exr_soft.Position(2) exr_soft.Position(3)];
            plot3(exr_soft.Position(1),exr_soft.Position(2),exr_soft.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(7)=1;
           end
        
           if exist('exl_soft','var')
            lm(8,1)={'exl_soft'};
            lm(8,2)={exl_soft.Position(1)};
            lm(8,3)={exl_soft.Position(2)};
            lm(8,4)={exl_soft.Position(3)};
            exocanthionsx_soft = [exl_soft.Position(1) exl_soft.Position(2) exl_soft.Position(3)];
            plot3(exl_soft.Position(1),exl_soft.Position(2),exl_soft.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(8)=1;
           end
           
           if exist('g_soft','var')
            lm(9,1)={'g_soft'};
            lm(9,2)={g_soft.Position(1)};
            lm(9,3)={g_soft.Position(2)};
            lm(9,4)={g_soft.Position(3)};
            glabella_soft = [g_soft.Position(1) g_soft.Position(2) g_soft.Position(3)];
            plot3(g_soft.Position(1),g_soft.Position(2),g_soft.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(9)=1;
           end
        
        
        if exist('gn','var')
            lm(10,1)={'gn'};
            lm(10,2)={gn.Position(1)};
            lm(10,3)={gn.Position(2)};
            lm(10,4)={gn.Position(3)};
            gnathion = [gn.Position(1) gn.Position(2) gn.Position(3)];
            plot3(gn.Position(1),gn.Position(2),gn.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(10)=1;
        end
        
        if exist('li','var')
            lm(11,1)={'li'};
            lm(11,2)={li.Position(1)};
            lm(11,3)={li.Position(2)};
            lm(11,4)={li.Position(3)};
            labialeinferius = [li.Position(1) li.Position(2) li.Position(3)];
            plot3(li.Position(1),li.Position(2),li.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(11)=1;
        end
        
         if exist('ls','var')
            lm(12,1)={'ls'};
            lm(12,2)={ls.Position(1)};
            lm(12,3)={ls.Position(2)};
            lm(12,4)={ls.Position(3)};
            labialesuperius = [ls.Position(1) ls.Position(2) ls.Position(3)];
            plot3(ls.Position(1),ls.Position(2),ls.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(12)=1;
         end
        
         
           if exist('mfdx','var')
            lm(13,1)={'mfdx'};
            lm(13,2)={mfdx.Position(1)};
            lm(13,3)={mfdx.Position(2)};
            lm(13,4)={mfdx.Position(3)};
            maxillofrontaledx = [mfdx.Position(1) mfdx.Position(2) mfdx.Position(3)];
            plot3(mfdx.Position(1),mfdx.Position(2),mfdx.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(13)=1;
           end
        
           if exist('mfsx','var')
            lm(14,1)={'mfsx'};
            lm(14,2)={mfsx.Position(1)};
            lm(14,3)={mfsx.Position(2)};
            lm(14,4)={mfsx.Position(3)};
            maxillofrontalesx = [mfsx.Position(1) mfsx.Position(2) mfsx.Position(3)];
            plot3(mfsx.Position(1),mfsx.Position(2),mfsx.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(14)=1;
           end
           
           
           if exist('n_soft','var')
            lm(15,1)={'n_soft'};
            lm(15,2)={n_soft.Position(1)};
            lm(15,3)={n_soft.Position(2)};
            lm(15,4)={n_soft.Position(3)};
            nasion_soft = [n_soft.Position(1) n_soft.Position(2) n_soft.Position(3)];
            plot3(n_soft.Position(1),n_soft.Position(2),n_soft.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(15)=1;
           end
           
           
         if exist('orr_soft','var')
            lm(16,1)={'orr_soft'};
            lm(16,2)={orr_soft.Position(1)};
            lm(16,3)={orr_soft.Position(2)};
            lm(16,4)={orr_soft.Position(3)};
            orbitaledx_soft = [orr_soft.Position(1) orr_soft.Position(2) orr_soft.Position(3)];
            plot3(orr_soft.Position(1),orr_soft.Position(2),orr_soft.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(16)=1;
           end
        
           if exist('orl_soft','var')
            lm(17,1)={'orl_soft'};
            lm(17,2)={orl_soft.Position(1)};
            lm(17,3)={orl_soft.Position(2)};
            lm(17,4)={orl_soft.Position(3)};
            orbitalesx_soft = [orl_soft.Position(1) orl_soft.Position(2) orl_soft.Position(3)];
            plot3(orl_soft.Position(1),orl_soft.Position(2),orl_soft.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(17)=1;
           end
           
            if exist('osr_soft','var')
            lm(18,1)={'osr_soft'};
            lm(18,2)={osr_soft.Position(1)};
            lm(18,3)={osr_soft.Position(2)};
            lm(18,4)={osr_soft.Position(3)};
            superiusdx_soft = [osr_soft.Position(1) osr_soft.Position(2) osr_soft.Position(3)];
            plot3(osr_soft.Position(1),osr_soft.Position(2),osr_soft.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(18)=1;
           end
        
           if exist('osl_soft','var')
            lm(19,1)={'osl_soft'};
            lm(19,2)={osl_soft.Position(1)};
            lm(19,3)={osl_soft.Position(2)};
            lm(19,4)={osl_soft.Position(3)};
            superiussx_soft = [osl_soft.Position(1) osl_soft.Position(2) osl_soft.Position(3)];
            plot3(osl_soft.Position(1),osl_soft.Position(2),osl_soft.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(19)=1;
           end
           
        
         if exist('pg','var')
            lm(20,1)={'pg'};
            lm(20,2)={pg.Position(1)};
            lm(20,3)={pg.Position(2)};
            lm(20,4)={pg.Position(3)};
            pogonion = [pg.Position(1) pg.Position(2) pg.Position(3)];
            plot3(pg.Position(1),pg.Position(2),pg.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(20)=1;
         end
        
           
          if exist('prn','var')
            lm(21,1)={'prn'};
            lm(21,2)={prn.Position(1)};
            lm(21,3)={prn.Position(2)};
            lm(21,4)={prn.Position(3)};
            pronasale = [prn.Position(1) prn.Position(2) prn.Position(3)];
            plot3(prn.Position(1),prn.Position(2),prn.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(21)=1;
          end
         
          
          if exist('se_soft','var')
            lm(22,1)={'se_soft'};
            lm(22,2)={se_soft.Position(1)};
            lm(22,3)={se_soft.Position(2)};
            lm(22,4)={se_soft.Position(3)};
            sellion_soft = [se_soft.Position(1) se_soft.Position(2) se_soft.Position(3)];
            plot3(se_soft.Position(1),se_soft.Position(2),se_soft.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(22)=1;
          end 
           
          
           if exist('sl','var')
            lm(23,1)={'sl'};
            lm(23,2)={sl.Position(1)};
            lm(23,3)={sl.Position(2)};
            lm(23,4)={sl.Position(3)};
            sublabiale = [sl.Position(1) sl.Position(2) sl.Position(3)];
            plot3(sl.Position(1),sl.Position(2),sl.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(23)=1;
           end 
           
          
            if exist('sn_soft','var')
            lm(24,1)={'sn_soft'};
            lm(24,2)={sn_soft.Position(1)};
            lm(24,3)={sn_soft.Position(2)};
            lm(24,4)={sn_soft.Position(3)};
            subnasale = [sn_soft.Position(1) sn_soft.Position(2) sn_soft.Position(3)];
            plot3(sn_soft.Position(1),sn_soft.Position(2),sn_soft.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(24)=1;
            end 
          
            
            if exist('ss','var')
            lm(25,1)={'ss'};
            lm(25,2)={ss.Position(1)};
            lm(25,3)={ss.Position(2)};
            lm(25,4)={ss.Position(3)};
            subspinale = [ss.Position(1) ss.Position(2) ss.Position(3)];
            plot3(ss.Position(1),ss.Position(2),ss.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(25)=1;
            end  
          
            
             if exist('sto','var')
            lm(26,1)={'sto'};
            lm(26,2)={sto.Position(1)};
            lm(26,3)={sto.Position(2)};
            lm(26,4)={sto.Position(3)};
            stomion = [sto.Position(1) sto.Position(2) sto.Position(3)];
            plot3(sto.Position(1),sto.Position(2),sto.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(26)=1;
             end 
          
             
             if exist('zyr_soft','var')
            lm(27,1)={'zyr_soft'};
            lm(27,2)={zyr_soft.Position(1)};
            lm(27,3)={zyr_soft.Position(2)};
            lm(27,4)={zyr_soft.Position(3)};
            zygiondx_soft = [zyr_soft.Position(1) zyr_soft.Position(2) zyr_soft.Position(3)];
            plot3(zyr_soft.Position(1),zyr_soft.Position(2),zyr_soft.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(27)=1;
           end
        
           if exist('zyl_soft','var')
            lm(28,1)={'zyl_soft'};
            lm(28,2)={zyl_soft.Position(1)};
            lm(28,3)={zyl_soft.Position(2)};
            lm(28,4)={zyl_soft.Position(3)};
            zygionsx_soft = [zyl_soft.Position(1) zyl_soft.Position(2) zyl_soft.Position(3)];
            plot3(zyl_soft.Position(1),zyl_soft.Position(2),zyl_soft.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(28)=1;
           end
          if exist('acl_soft','var')
            lm(29,1)={'acl_soft'};
            lm(29,2)={acl_soft.Position(1)};
            lm(29,3)={acl_soft.Position(2)};
            lm(29,4)={acl_soft.Position(3)};
            alarcurvaturesx_soft = [acl_soft.Position(1) acl_soft.Position(2) acl_soft.Position(3)];
            plot3(acl_soft.Position(1),acl_soft.Position(2),acl_soft.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(29)=1;
           end
           if exist('acr_soft','var')
            lm(30,1)={'acr_soft'};
            lm(30,2)={acr_soft.Position(1)};
            lm(30,3)={acr_soft.Position(2)};
            lm(30,4)={acr_soft.Position(3)};
            alarcurvaturedx_soft = [acr_soft.Position(1) acr_soft.Position(2) acr_soft.Position(3)];
            plot3(acr_soft.Position(1),acr_soft.Position(2),acr_soft.Position(3),'r.', 'markers', 30);
            numberoflandmarks = numberoflandmarks +1;
    
        else
            err(30)=1;
           end
           
    landmarks = table2array(lm);
    landmarksnonames = table2array(lm(:,2:4));
    


    %%%%%per hard
    f2 = figure;
    surf(Xb,Yb,Zb);
    view(0,90)
    title(['Hard Tissue Landmark - ', patient{1},' ', name_patient]);
    hold on
    
    
    numberoflandmarks_hard_hard = 0;
    
    lm_hard=table('Size',[15 4],'VariableTypes',{'string','double','double','double'});
        err_hard=zeros(26,1);
        
        if exist('a','var')
            lm_hard(1,1)={'a'};
            lm_hard(1,2)={a.Position(1)};
            lm_hard(1,3)={a.Position(2)};
            lm_hard(1,4)={a.Position(3)};
            apoint = [a.Position(1) a.Position(2) a.Position(3)];
            plot3(a.Position(1),a.Position(2),a.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(1)=1;
        end
        
           if exist('ANS','var')
            lm_hard(2,1)={'ANS'};
            lm_hard(2,2)={ANS.Position(1)}; 
            lm_hard(2,3)={ANS.Position(2)}; 
            lm_hard(2,4)={ANS.Position(3)}; 
            anteriornasalspline = [ANS.Position(1) ANS.Position(2) ANS.Position(3)]; 
            plot3(ANS.Position(1),ANS.Position(2),ANS.Position(3),'r.', 'markers', 30); 
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(2)=1;
           end
        
           if exist('b','var')
            lm_hard(3,1)={'b'};
            lm_hard(3,2)={b.Position(1)};
            lm_hard(3,3)={b.Position(2)};
            lm_hard(3,4)={b.Position(3)};
            bpoint = [b.Position(1) b.Position(2) b.Position(3)];
            plot3(b.Position(1),b.Position(2),b.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(3)=1;
           end
        
           if exist('fzdx','var')
            lm_hard(4,1)={'fzdx'};
            lm_hard(4,2)={fzdx.Position(1)};
            lm_hard(4,3)={fzdx.Position(2)};
            lm_hard(4,4)={fzdx.Position(3)};
            frontozigomaticodx = [fzdx.Position(1) fzdx.Position(2) fzdx.Position(3)];
            plot3(fzdx.Position(1),fzdx.Position(2),fzdx.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(4)=1;
           end
           
           if exist('fzsx','var')
            lm_hard(5,1)={'fzsx'};
            lm_hard(5,2)={fzsx.Position(1)};
            lm_hard(5,3)={fzsx.Position(2)};
            lm_hard(5,4)={fzsx.Position(3)};
            frontozigomaticosx = [fzsx.Position(1) fzsx.Position(2) fzsx.Position(3)];
            plot3(fzsx.Position(1),fzsx.Position(2),fzsx.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(5)=1;
           end
        
           if exist('godx','var')
            lm_hard(6,1)={'godx'};
            lm_hard(6,2)={godx.Position(1)};
            lm_hard(6,3)={godx.Position(2)};
            lm_hard(6,4)={godx.Position(3)};
            goniondx = [godx.Position(1) godx.Position(2) godx.Position(3)];
            plot3(godx.Position(1),godx.Position(2),godx.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(6)=1;
           end
           
            if exist('gosx','var')
            lm_hard(7,1)={'gosx'};
            lm_hard(7,2)={gosx.Position(1)};
            lm_hard(7,3)={gosx.Position(2)};
            lm_hard(7,4)={gosx.Position(3)};
            gonionsx = [gosx.Position(1) gosx.Position(2) gosx.Position(3)];
            plot3(gosx.Position(1),gosx.Position(2),gosx.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(7)=1;
           end
        
           if exist('men','var')
            lm_hard(8,1)={'men'};
            lm_hard(8,2)={men.Position(1)};
            lm_hard(8,3)={men.Position(2)};
            lm_hard(8,4)={men.Position(3)};
            menton = [men.Position(1) men.Position(2) men.Position(3)];
            plot3(men.Position(1),men.Position(2),men.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(8)=1;
           end
           
           if exist('n_hard','var')
            lm_hard(9,1)={'n_hard'};
            lm_hard(9,2)={n_hard.Position(1)};
            lm_hard(9,3)={n_hard.Position(2)};
            lm_hard(9,4)={n_hard.Position(3)};
            nasion_hard = [n_hard.Position(1) n_hard.Position(2) n_hard.Position(3)];
            plot3(n_hard.Position(1),n_hard.Position(2),n_hard.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(9)=1;
           end
        
        
        if exist('orr_hard','var')
            lm_hard(10,1)={'orr_hard'};
            lm_hard(10,2)={orr_hard.Position(1)};
            lm_hard(10,3)={orr_hard.Position(2)};
            lm_hard(10,4)={orr_hard.Position(3)};
            orbitaledx_hard = [orr_hard.Position(1) orr_hard.Position(2) orr_hard.Position(3)];
            plot3(orr_hard.Position(1),orr_hard.Position(2),orr_hard.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(10)=1;
        end
        
        if exist('orl_hard','var')
            lm_hard(11,1)={'orl_hard'};
            lm_hard(11,2)={orl_hard.Position(1)};
            lm_hard(11,3)={orl_hard.Position(2)};
            lm_hard(11,4)={orl_hard.Position(3)};
            orbitalesx_hard = [orl_hard.Position(1) orl_hard.Position(2) orl_hard.Position(3)];
            plot3(orl_hard.Position(1),orl_hard.Position(2),orl_hard.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(11)=1;
        end
        
         if exist('pog','var')
            lm_hard(12,1)={'pog'};
            lm_hard(12,2)={pog.Position(1)};
            lm_hard(12,3)={pog.Position(2)};
            lm_hard(12,4)={pog.Position(3)};
            pogonion = [pog.Position(1) pog.Position(2) pog.Position(3)];
            plot3(pog.Position(1),pog.Position(2),pog.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(12)=1;
         end
        
         
           if exist('ui','var')
            lm_hard(13,1)={'ui'};
            lm_hard(13,2)={ui.Position(1)};
            lm_hard(13,3)={ui.Position(2)};
            lm_hard(13,4)={ui.Position(3)};
            upperincisor = [ui.Position(1) ui.Position(2) ui.Position(3)];
            plot3(ui.Position(1),ui.Position(2),ui.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(13)=1;
           end
        
                
             
           if exist('zyr_hard','var')
            lm_hard(14,1)={'zyr_hard'};
            lm_hard(14,2)={zyr_hard.Position(1)};
            lm_hard(14,3)={zyr_hard.Position(2)};
            lm_hard(14,4)={zyr_hard.Position(3)};
            zygiondx_hard = [zyr_hard.Position(1) zyr_hard.Position(2) zyr_hard.Position(3)];
            plot3(zyr_hard.Position(1),zyr_hard.Position(2),zyr_hard.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(14)=1;
           end
        
           if exist('zyl_hard','var')
            lm_hard(15,1)={'zyl_hard'};
            lm_hard(15,2)={zyl_hard.Position(1)};
            lm_hard(15,3)={zyl_hard.Position(2)};
            lm_hard(15,4)={zyl_hard.Position(3)};
            zygionsx_hard = [zyl_hard.Position(1) zyl_hard.Position(2) zyl_hard.Position(3)];
            plot3(zyl_hard.Position(1),zyl_hard.Position(2),zyl_hard.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(15)=1;
           end
            if exist('sn_hard','var')
            lm_hard(16,1)={'sn_hard'};
            lm_hard(16,2)={sn_hard.Position(1)};
            lm_hard(16,3)={sn_hard.Position(2)};
            lm_hard(16,4)={sn_hard.Position(3)};
            subnasale_hard = [sn_hard.Position(1) sn_hard.Position(2) sn_hard.Position(3)];
            plot3(sn_hard.Position(1),sn_hard.Position(2),sn_hard.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(16)=1;
           end
           
            if exist('se_hard','var')
            lm_hard(17,1)={'se_hard'};
            lm_hard(17,2)={se_hard.Position(1)};
            lm_hard(17,3)={se_hard.Position(2)};
            lm_hard(17,4)={se_hard.Position(3)};
            sellion_hard = [se_hard.Position(1) se_hard.Position(2) se_hard.Position(3)];
            plot3(se_hard.Position(1),se_hard.Position(2),se_hard.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(17)=1;
           end
             
            if exist('osr_hard','var')
            lm_hard(18,1)={'osr_hard'};
            lm_hard(18,2)={osr_hard.Position(1)};
            lm_hard(18,3)={osr_hard.Position(2)};
            lm_hard(18,4)={osr_hard.Position(3)};
            superiusdx_hard = [osr_hard.Position(1) osr_hard.Position(2) osr_hard.Position(3)];
            plot3(osr_hard.Position(1),osr_hard.Position(2),osr_hard.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(18)=1;
            end

            if exist('osl_hard','var')
            lm_hard(19,1)={'osl_hard'};
            lm_hard(19,2)={osl_hard.Position(1)};
            lm_hard(19,3)={osl_hard.Position(2)};
            lm_hard(19,4)={osl_hard.Position(3)};
            superiussx_hard = [osl_hard.Position(1) osl_hard.Position(2) osl_hard.Position(3)];
            plot3(osl_hard.Position(1),osl_hard.Position(2),osl_hard.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(19)=1;
           end
           

            if exist('g_hard','var')
            lm_hard(20,1)={'g_hard'};
            lm_hard(20,2)={g_hard.Position(1)};
            lm_hard(20,3)={g_hard.Position(2)};
            lm_hard(20,4)={g_hard.Position(3)};
            glabella_hard = [g_hard.Position(1) g_hard.Position(2) g_hard.Position(3)];
            plot3(g_hard.Position(1),g_hard.Position(2),g_hard.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(20)=1;
           end
           
            if exist('acl_hard','var')
            lm_hard(21,1)={'acl_hard'};
            lm_hard(21,2)={acl_hard.Position(1)};
            lm_hard(21,3)={acl_hard.Position(2)};
            lm_hard(21,4)={acl_hard.Position(3)};
            alarcurvaturesx_hard = [acl_hard.Position(1) acl_hard.Position(2) acl_hard.Position(3)];
            plot3(acl_hard.Position(1),acl_hard.Position(2),acl_hard.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(21)=1;
            end

            if exist('acr_hard','var')
            lm_hard(22,1)={'acr_hard'};
            lm_hard(22,2)={acr_hard.Position(1)};
            lm_hard(22,3)={acr_hard.Position(2)};
            lm_hard(22,4)={acr_hard.Position(3)};
            alarcurvaturedx_hard = [acr_hard.Position(1) acr_hard.Position(2) acr_hard.Position(3)];
            plot3(acr_hard.Position(1),acr_hard.Position(2),acr_hard.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(22)=1;
            end
            
            if exist('exl_hard','var')
            lm_hard(23,1)={'exl_hard'};
            lm_hard(23,2)={exl_hard.Position(1)};
            lm_hard(23,3)={exl_hard.Position(2)};
            lm_hard(23,4)={exl_hard.Position(3)};
            exocanthionsx_hard = [exl_hard.Position(1) exl_hard.Position(2) exl_hard.Position(3)];
            plot3(exl_hard.Position(1),exl_hard.Position(2),exl_hard.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(23)=1;
            end
            
            if exist('exr_hard','var')
            lm_hard(24,1)={'exr_hard'};
            lm_hard(24,2)={exr_hard.Position(1)};
            lm_hard(24,3)={exr_hard.Position(2)};
            lm_hard(24,4)={exr_hard.Position(3)};
            exocanthiondx_hard = [exr_hard.Position(1) exr_hard.Position(2) exr_hard.Position(3)];
            plot3(exr_hard.Position(1),exr_hard.Position(2),exr_hard.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(24)=1;
            end

            if exist('enr_hard','var')
            lm_hard(25,1)={'enr_hard'};
            lm_hard(25,2)={enr_hard.Position(1)};
            lm_hard(25,3)={enr_hard.Position(2)};
            lm_hard(25,4)={enr_hard.Position(3)};
            endocanthiondx_hard = [enr_hard.Position(1) enr_hard.Position(2) enr_hard.Position(3)];
            plot3(enr_hard.Position(1),enr_hard.Position(2),enr_hard.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(25)=1;
            end
            
            if exist('enl_hard','var')
            lm_hard(26,1)={'enl_hard'};
            lm_hard(26,2)={enl_hard.Position(1)};
            lm_hard(26,3)={enl_hard.Position(2)};
            lm_hard(26,4)={enl_hard.Position(3)};
            endocanthionsx_hard = [enl_hard.Position(1) enl_hard.Position(2) enl_hard.Position(3)];
            plot3(enl_hard.Position(1),enl_hard.Position(2),enl_hard.Position(3),'r.', 'markers', 30);
            numberoflandmarks_hard_hard = numberoflandmarks_hard_hard +1;
    
        else
            err_hard(26)=1;
           end
   
           landmarks_hard = table2array(lm_hard);
    landmarks_hardnonames = table2array(lm_hard(:,2:4));
    
    mkdir(fullfile('hmr', 'landmark'));
    save(sprintf('hmr/landmark/%s', name));
    patient = strsplit(name, '_');
    name_patient = strcat(patient{1},'_',patient{2});
    mkdir(fullfile('hmr', 'landmark_photos'), name_patient);
    saveas(f1, sprintf('hmr/landmark_photos/%s/SoftTissue_Landmark.png', name_patient));
    saveas(f2, sprintf('hmr/landmark_photos/%s/HardTissue_Landmark.png', name_patient));
    
    
   
    calculate_thickness(path3+landmarks_file(j))


    
end