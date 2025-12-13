lvr1_transfer_characteristics = table( ...
    [1.83; 2.03; 2.54; 3.54; 4.31; 5.61; 7.14; 9.28; 10.65; 12.03; 14.28], ...
    [1.83; 2.03; 2.54; 3.54; 4.28; 5.18; 5.52; 5.59; 5.62; 5.64; 5.68] ...
    );

lvr2_transfer_characteristics = table( ...
    [1.68; 2.40; 3.92; 5.05; 5.91; 6.47; 7.06; 7.84; 8.97; 10.58; 12.23], ...
    [1.68; 2.40; 3.92; 4.92; 5.36; 5.49; 5.53; 5.54; 5.54; 5.54; 5.54] ...
    );

lvr5_transfer_characteristics = table( ...
    [1.83; 2.46; 3.04; 4.54; 5.67; 6.07; 6.8; 7.05; 8.44; 10.33; 14.85], ...
    [0; 0.07; 0.63; 2.95; 4.55; 4.74; 4.97; 5.02; 5.05; 5.05; 5.05] ...
    );

lvr1_noload_characteristics = table( ...
    [1.48; 2.54; 3.70; 4.41; 5.36; 6.36; 7.21; 8.11; 9.14; 10.22; 11.57; 12.86; 13.87; 14.32], ...
    [0.96; 1.64; 2.39; 2.84; 3.47; 4.09; 4.63; 5.10; 5.40; 5.52; 5.57; 5.59; 5.61; 5.62] ...
    );

lvr2_noload_characteristics = table( ...
    [1.40; 2.22; 3.36; 4.33; 5.27; 6.20; 7.21; 8.25; 10.03; 14.56], ...
    [1.13; 1.94; 3; 3.88; 4.72; 5.24; 5.44; 5.46; 5.46; 5.46] ...
    );

lvr5_noload_characteristics = table( ...
    [1.74; 2.03; 4.36; 5.28; 6.67; 7.53; 8.21; 9.08; 10.02; 14.62], ...
    [0; 0.09; 1.34; 3.77; 4.77; 5; 5.05; 5.05; 5.05; 5.05] ...
    );

lvr1_load_characteristics = table( ...
    [5.60; 5.54; 5.45; 5.25; 4.55; 3.20; 1.33; 0.97], ...
    [0; 29.6; 35.5; 43.5; 53.2; 66; 83.7; 87.3] ...
    );

lvr2_load_characteristics = table( ...
    [5.34; 5.48; 5.44; 5.11; 4.90; 3.97; 1.89; 0.91; 0.43], ...
    [0; 24.8; 33; 41.5; 41.9; 40.4; 40; 39.3; 38.9] ...
    );

lvr5_load_characteristics = table( ...
    [5.05; 5.05; 5.03; 5; 5; 5.04; 5.04; 5.03], ...
    [0; 38; 160; 443; 340; 54.2; 79; 186] ...
    );

% -- Regulator 1 --
dataList(1).name = "lvr1"; 
dataList(1).transfer = lvr1_transfer_characteristics;
dataList(1).load = lvr1_load_characteristics;

% -- Regulator 2 --
dataList(2).name = "lvr2"; 
dataList(2).transfer = lvr2_transfer_characteristics;
dataList(2).load = lvr2_load_characteristics;

% -- Regulator 5 --
dataList(3).name = "lvr5"; 
dataList(3).transfer = lvr5_transfer_characteristics;
dataList(3).load = lvr5_load_characteristics;


maxTransX = 0; maxTransY = 0;
maxLoadX = 0;  maxLoadY = 0;

for i = 1:length(dataList)
    % Find max for Transfer (Var1=X, Var2=Y)
    maxTransX = max(maxTransX, max(dataList(i).transfer.Var1));
    maxTransY = max(maxTransY, max(dataList(i).transfer.Var2));
    
    % Find max for Load/Output (Var2=X, Var1=Y)
    maxLoadX = max(maxLoadX, max(dataList(i).load.Var2));
    maxLoadY = max(maxLoadY, max(dataList(i).load.Var1));
end

paddingMultiplier = 1.10;

globalTransLimsX = [0, maxTransX * paddingMultiplier];
globalTransLimsY = [0, maxTransY * paddingMultiplier];

globalLoadLimsX  = [0, maxLoadX * paddingMultiplier];
globalLoadLimsY  = [0, maxLoadY * paddingMultiplier];

for i = 1:length(dataList)
    currentReg = dataList(i);
    
    % TRANSFER CHAR GRAPH
    f = figure('Visible', 'off');
    hold on;
    plot(currentReg.transfer.Var1, currentReg.transfer.Var2, '-o', 'LineWidth', 2);
    hold off;
    grid on
    xlim(globalTransLimsX);
    ylim(globalTransLimsY);
    title('Transfer Characteristics for regulator ' + upper(currentReg.name));
    xlabel('U_{in} (V)');
    ylabel('U_{out} (V)');
    legend show;

    saveas(f, "figures/transfer_" + currentReg.name + ".png");
    close(f);

    % NOLOAD CHAR GRAPH
    f = figure('Visible', 'off');
    hold on;
    plot(currentReg.load.Var2, currentReg.load.Var1, '-o', 'LineWidth', 2);
    hold off;
    grid on;
    xlim(globalLoadLimsX);
    ylim(globalLoadLimsY);
    title('Output Characteristics for regulator ' + upper(currentReg.name));
    xlabel('U_{in} (V)');
    ylabel('U_{out} (V)');
    legend show;

    saveas(f, "figures/load_" + currentReg.name + ".png");
    close(f);

    fprintf("Saved images for regulator %s\n", currentReg.name);
end