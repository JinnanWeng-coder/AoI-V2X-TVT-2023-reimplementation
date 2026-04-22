%% Algorithm 3 (MADDPG_FDec) 结果可视化脚本
clear; clc; close all;

% 设置全局绘图属性，确保图片清晰、专业
set(0, 'DefaultLineLineWidth', 2);
set(0, 'DefaultAxesFontSize', 12);
set(0, 'DefaultAxesFontWeight', 'bold');
set(0, 'DefaultFigureColor', [1 1 1]);

%% 1. 训练收敛情况 (Reward Convergence)
if exist('reward.mat', 'file')
    load('reward.mat'); % 数据维度通常为 [n_platoon, n_episode]
    avg_reward = mean(reward, 1); 
    
    figure('Name', 'Algo3 Reward');
    plot(avg_reward, 'Color', [0.9290 0.6940 0.1250]); % 橙黄色区分
    grid on;
    title('Algorithm 3: Training Convergence (Average Reward)');
    xlabel('Episode');
    ylabel('Local Reward Sum');
    saveas(gcf, 'Algo3_Result_1_Reward.png');
end

%% 2. 信息新鲜度趋势 (AoI Performance)
if exist('AoI.mat', 'file')
    load('AoI.mat');
    avg_aoi = mean(AoI, 1);
    
    figure('Name', 'Algo3 AoI Trend');
    plot(avg_aoi, 'Color', [0.4940 0.1840 0.5560]); % 紫色
    grid on;
    title('Algorithm 3: System Information Freshness (AoI)');
    xlabel('Episode');
    ylabel('Average AoI (ms/steps)');
    saveas(gcf, 'Algo3_Result_2_AoI_Trend.png');
end

%% 3. 单周期内 V2V 任务完成度 (Demand Depletion)
if exist('demand.mat', 'file')
    load('demand.mat');
    % 提取最后 100 轮中最后一轮的 Demand 消耗曲线
    % demand 结构为 [n_platoon, 100, steps_per_episode]
    last_episode_demand = squeeze(mean(demand(:, end, :), 1));
    
    figure('Name', 'Algo3 Demand Flow');
    plot(last_episode_demand, 'Color', [0.4660 0.6740 0.1880], 'LineStyle', '--');
    grid on;
    title('Intra-Episode: V2V Demand Depletion Rate');
    xlabel('Step');
    ylabel('Remaining Data (bits)');
    saveas(gcf, 'Algo3_Result_3_Demand_Step.png');
end

%% 4. 实时 AoI 演进 (AoI Sawtooth Evolution)
if exist('AoI_evolution.mat', 'file')
    load('AoI_evolution.mat');
    % 展示最后 100 轮中最后一轮的实时波动
    last_aoi_evol = squeeze(mean(AoI_evolution(:, end, :), 1));
    
    figure('Name', 'Algo3 AoI Sawtooth');
    plot(last_aoi_evol, 'b');
    grid on;
    title('Intra-Episode: AoI Sawtooth Waveform (Real-time)');
    xlabel('Step');
    ylabel('Instantaneous AoI');
    saveas(gcf, 'Algo3_Result_4_AoI_Evolution.png');
end

%% 5. V2I 与 V2V 资源竞争分析 (Throughput)
if exist('V2I.mat', 'file') && exist('V2V.mat', 'file')
    load('V2I.mat');
    load('V2V.mat');
    
    % 计算平均吞吐量
    mean_v2i = squeeze(mean(mean(V2I, 1), 2));
    mean_v2v = squeeze(mean(mean(V2V, 1), 2));
    
    figure('Name', 'Algo3 Rate Comparison');
    set(gcf, 'Color', 'w'); % 设置背景为白色
    
    % 左轴设置
    yyaxis left
    plot(mean_v2i, '-', 'LineWidth', 1.5, 'DisplayName', 'V2I Rate (Cellular)');
    ylabel('V2I Rate (bps)');
    
    % 右轴设置
    yyaxis right
    plot(mean_v2v, ':', 'LineWidth', 2, 'DisplayName', 'V2V Rate (Platoon)');
    ylabel('V2V Rate (bps)');
    
    grid on;
    title('Algorithm 3: Multi-Link Rate Balancing');
    xlabel('Step');
    
    % --- 核心修改：图例放在下方外部，且横向排列 ---
    legend('Location', 'southoutside', 'Orientation', 'horizontal'); 
    % --------------------------------------------
    
    % 导出图片
    saveas(gcf, 'Algo3_Result_5_Rate_Comparison.png');
end

fprintf('Algorithm 3 所有指标可视化已完成并保存到当前文件夹。\n');