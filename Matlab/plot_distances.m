

function[mean_men_u30,mean_men_30_50,mean_men_o50,mean_women_u30,mean_women_30_50,mean_women_o50] =plot_distances(men_u30,men_30_50, men_o50, women_u30, women_30_50,women_o50, landmark_names)
   
    mean_men_u30 = mean(men_u30, 2, 'omitnan');
    mean_men_30_50 = mean(men_30_50, 2, 'omitnan');
    mean_men_o50 = mean(men_o50, 2, 'omitnan');
    mean_women_u30 = mean(women_u30, 2, 'omitnan');
    mean_women_30_50 = mean(women_30_50, 2, 'omitnan');
    mean_women_o50 = mean(women_o50, 2, 'omitnan');
    
    figure;
    
    plot(1:10, mean_men_u30,'DisplayName', 'Under 25');
    title('Men distances');
    hold on;
    plot(1:10,mean_men_30_50, 'DisplayName','25-60');
    plot(1:10,mean_men_o50, 'DisplayName','Over 60');
    xlabel('Landmark');
    ylabel('Distances');
    xticks(1:length(landmark_names));
    xticklabels(landmark_names);
    legend('show');

    figure;
    
    plot(1:10, mean_women_u30,'DisplayName', 'Under 25');
    title('Women distances');
    hold on;
    plot(1:10,mean_women_30_50, 'DisplayName','25-60');
    plot(1:10,mean_women_o50, 'DisplayName','Over 60');
    xlabel('Landmark');
    ylabel('Distances');
    xticks(1:length(landmark_names));
    xticklabels(landmark_names);
    legend('show');







end