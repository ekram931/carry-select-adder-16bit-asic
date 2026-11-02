<!DOCTYPE html>
<html lang="en" class="dark">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>16-bit CSLA ASIC Physical Design Visualizer</title>
  <!-- Tailwind CSS -->
  <script src="https://cdn.tailwindcss.com"></script>
  <!-- FontAwesome Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Fira+Code:wght@400;500;600;700&family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

  <script>
    tailwind.config = {
      darkMode: 'class',
      theme: {
        extend: {
          colors: {
            brand: {
              50: '#eef6ff',
              100: '#e0edff',
              400: '#38bdf8',
              500: '#0284c7',
              600: '#0284c7',
              900: '#0f172a',
            },
            asic: {
              cyan: '#00f2fe',
              blue: '#4facfe',
              purple: '#7f00ff',
              pink: '#ff007f',
              green: '#00ff87',
              amber: '#ffb703'
            }
          },
          fontFamily: {
            sans: ['Inter', 'sans-serif'],
            mono: ['Fira Code', 'monospace'],
          },
          animation: {
            'pulse-slow': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
            'glow': 'glow 2s ease-in-out infinite alternate',
          },
          keyframes: {
            glow: {
              '0%': { boxShadow: '0 0 5px rgba(0, 242, 254, 0.4), 0 0 10px rgba(0, 242, 254, 0.2)' },
              '100%': { boxShadow: '0 0 20px rgba(0, 242, 254, 0.8), 0 0 30px rgba(79, 172, 254, 0.6)' }
            }
          }
        }
      }
    }
  </script>

  <style>
    /* Custom Scrollbar */
    ::-webkit-scrollbar {
      width: 8px;
      height: 8px;
    }
    ::-webkit-scrollbar-track {
      background: #090d16;
    }
    ::-webkit-scrollbar-thumb {
      background: #1e293b;
      border-radius: 4px;
    }
    ::-webkit-scrollbar-thumb:hover {
      background: #334155;
    }
    
    .glass-panel {
      background: rgba(15, 23, 42, 0.75);
      backdrop-filter: blur(12px);
      -webkit-backdrop-filter: blur(12px);
      border: 1px solid rgba(255, 255, 255, 0.08);
    }
    
    .neon-border-cyan {
      box-shadow: 0 0 15px rgba(0, 242, 254, 0.2);
      border: 1px solid rgba(0, 242, 254, 0.4);
    }
    
    .neon-border-purple {
      box-shadow: 0 0 15px rgba(127, 0, 255, 0.2);
      border: 1px solid rgba(127, 0, 255, 0.4);
    }

    .tree-line::before {
      content: '';
      position: absolute;
      left: 19px;
      top: 0;
      bottom: 0;
      width: 2px;
      background: rgba(51, 65, 85, 0.5);
    }
  </style>
</head>

<body class="bg-[#070a12] text-slate-200 font-sans min-h-screen flex flex-col justify-between selection:bg-cyan-500 selection:text-slate-900">

  <!-- Notification Toast -->
  <div id="toast" class="fixed bottom-5 right-5 z-50 flex items-center gap-3 bg-emerald-950 border border-emerald-500/50 text-emerald-200 px-4 py-3 rounded-xl shadow-2xl transition-all duration-300 opacity-0 pointer-events-none translate-y-4">
    <i class="fa-solid fa-circle-check text-emerald-400 text-lg"></i>
    <span id="toast-msg" class="text-sm font-medium">Text copied to clipboard!</span>
  </div>

  <!-- Header Banner -->
  <header class="border-b border-slate-800/80 bg-[#0a0f1d]/90 sticky top-0 z-40 backdrop-blur-md">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
      <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div class="flex items-center space-x-3">
          <div class="p-2.5 rounded-xl bg-gradient-to-tr from-cyan-500/20 to-blue-600/20 border border-cyan-500/30 text-cyan-400">
            <i class="fa-solid fa-[#microchip] text-2xl"></i>
          </div>
          <div>
            <div class="flex items-center gap-2">
              <h1 class="text-xl font-bold bg-gradient-to-r from-cyan-400 via-blue-400 to-purple-400 bg-clip-text text-transparent">
                16-bit Carry Select Adder (CSLA)
              </h1>
              <span class="px-2 py-0.5 text-xs font-semibold rounded-full bg-cyan-950 text-cyan-300 border border-cyan-800">Nangate45nm</span>
            </div>
            <p class="text-xs text-slate-400 mt-0.5">RTL-to-GDSII Physical Design Architecture & Directory Explorer</p>
          </div>
        </div>

        <div class="flex items-center gap-3">
          <a href="https://github.com/ekram931/carry-select-adder-16bit-asic" target="_blank" rel="noopener" class="flex items-center gap-2 px-3.5 py-2 text-xs font-medium bg-slate-800/80 hover:bg-slate-700 text-slate-200 rounded-lg border border-slate-700 transition">
            <i class="fa-brands fa-github text-sm"></i>
            <span>GitHub Repository</span>
          </a>
          <button onclick="copyMarkdownTree()" class="flex items-center gap-2 px-3.5 py-2 text-xs font-medium bg-gradient-to-r from-cyan-600 to-blue-600 hover:from-cyan-500 hover:to-blue-500 text-white rounded-lg shadow-lg shadow-cyan-950/50 transition">
            <i class="fa-solid fa-copy"></i>
            <span>Copy Tree MD</span>
          </button>
        </div>
      </div>
    </div>
  </header>

  <!-- Main Content -->
  <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full space-y-8 flex-grow">

    <!-- Overview Stats Cards -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
      <div class="glass-panel p-4 rounded-xl flex items-center space-x-4 border-l-4 border-l-cyan-400">
        <div class="p-3 bg-cyan-500/10 rounded-lg text-cyan-400">
          <i class="fa-solid fa-ruler-combined text-xl"></i>
        </div>
        <div>
          <p class="text-xs font-medium text-slate-400 uppercase tracking-wider">Floorplan Die Area</p>
          <p class="text-lg font-bold text-slate-100 font-mono">150 × 150 µm²</p>
        </div>
      </div>

      <div class="glass-panel p-4 rounded-xl flex items-center space-x-4 border-l-4 border-l-purple-400">
        <div class="p-3 bg-purple-500/10 rounded-lg text-purple-400">
          <i class="fa-solid fa-vector-square text-xl"></i>
        </div>
        <div>
          <p class="text-xs font-medium text-slate-400 uppercase tracking-wider">Core Area</p>
          <p class="text-lg font-bold text-slate-100 font-mono">140 × 140 µm²</p>
        </div>
      </div>

      <div class="glass-panel p-4 rounded-xl flex items-center space-x-4 border-l-4 border-l-emerald-400">
        <div class="p-3 bg-emerald-500/10 rounded-lg text-emerald-400">
          <i class="fa-solid fa-layer-group text-xl"></i>
        </div>
        <div>
          <p class="text-xs font-medium text-slate-400 uppercase tracking-wider">PDK Technology</p>
          <p class="text-lg font-bold text-slate-100 font-mono">Nangate 45nm</p>
        </div>
      </div>

      <div class="glass-panel p-4 rounded-xl flex items-center space-x-4 border-l-4 border-l-amber-400">
        <div class="p-3 bg-amber-500/10 rounded-lg text-amber-400">
          <i class="fa-solid fa-microchip text-xl"></i>
        </div>
        <div>
          <p class="text-xs font-medium text-slate-400 uppercase tracking-wider">Adder Sub-blocks</p>
          <p class="text-lg font-bold text-slate-100 font-mono">4 × 4-bit CLA</p>
        </div>
      </div>
    </div>

    <!-- Main Grid: Tree Viewer + Code Inspector -->
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">

      <!-- Interactive Directory Tree (5 cols) -->
      <div class="lg:col-span-5 glass-panel rounded-2xl p-5 border border-slate-800 flex flex-col justify-between">
        <div>
          <div class="flex items-center justify-between pb-4 border-b border-slate-800 mb-4">
            <div class="flex items-center gap-2">
              <i class="fa-solid fa-folder-tree text-cyan-400"></i>
              <h2 class="font-bold text-slate-100 text-sm tracking-wide uppercase">Interactive Project Tree</h2>
            </div>
            <span class="text-xs text-slate-500 font-mono">Click files to preview</span>
          </div>

          <!-- Tree Root -->
          <div class="font-mono text-sm space-y-1">
            <div class="flex items-center gap-2 py-1.5 px-2 rounded-lg bg-cyan-950/30 text-cyan-300 font-semibold border border-cyan-800/40">
              <i class="fa-solid fa-folder-open text-cyan-400"></i>
              <span>carry-select-adder-16bit-asic/</span>
            </div>

            <!-- Subtree -->
            <div class="pl-4 relative tree-line space-y-1 pt-1">
              
              <!-- designs/ -->
              <div class="space-y-1">
                <div onclick="toggleFolder('designs-content')" class="flex items-center gap-2 py-1 px-2 rounded hover:bg-slate-800/60 cursor-pointer text-slate-300 transition group">
                  <i id="designs-icon" class="fa-solid fa-folder-open text-amber-400 text-xs"></i>
                  <span class="font-medium group-hover:text-amber-300">designs/</span>
                </div>

                <div id="designs-content" class="pl-4 relative tree-line space-y-1">
                  
                  <!-- src/ -->
                  <div class="space-y-1">
                    <div onclick="toggleFolder('src-content')" class="flex items-center gap-2 py-1 px-2 rounded hover:bg-slate-800/60 cursor-pointer text-slate-300 transition group">
                      <i id="src-icon" class="fa-solid fa-folder-open text-amber-400 text-xs"></i>
                      <span class="font-medium group-hover:text-amber-300">src/</span>
                    </div>

                    <div id="src-content" class="pl-4 relative tree-line space-y-1">
                      
                      <!-- carry_select_adder_16bit/ -->
                      <div class="space-y-1">
                        <div onclick="toggleFolder('csla-src-content')" class="flex items-center gap-2 py-1 px-2 rounded hover:bg-slate-800/60 cursor-pointer text-slate-300 transition group">
                          <i id="csla-src-icon" class="fa-solid fa-folder-open text-amber-400 text-xs"></i>
                          <span class="font-medium group-hover:text-amber-300">carry_select_adder_16bit/</span>
                        </div>

                        <div id="csla-src-content" class="pl-4 relative tree-line space-y-1">
                          <div onclick="selectFile('top_v')" class="file-item flex items-center justify-between py-1 px-2 rounded hover:bg-cyan-950/40 cursor-pointer text-slate-300 border border-transparent hover:border-cyan-500/30 transition text-xs">
                            <div class="flex items-center gap-2">
                              <i class="fa-solid fa-file-code text-blue-400"></i>
                              <span>carry_select_adder_16bit.v</span>
                            </div>
                            <span class="text-[10px] text-blue-400/80 bg-blue-950 px-1.5 py-0.5 rounded">RTL Top</span>
                          </div>

                          <div onclick="selectFile('cla_v')" class="file-item flex items-center justify-between py-1 px-2 rounded hover:bg-cyan-950/40 cursor-pointer text-slate-300 border border-transparent hover:border-cyan-500/30 transition text-xs">
                            <div class="flex items-center gap-2">
                              <i class="fa-solid fa-file-code text-blue-400"></i>
                              <span>CLA_adder.v</span>
                            </div>
                            <span class="text-[10px] text-slate-400">4-bit CLA</span>
                          </div>

                          <div onclick="selectFile('mux_v')" class="file-item flex items-center justify-between py-1 px-2 rounded hover:bg-cyan-950/40 cursor-pointer text-slate-300 border border-transparent hover:border-cyan-500/30 transition text-xs">
                            <div class="flex items-center gap-2">
                              <i class="fa-solid fa-file-code text-blue-400"></i>
                              <span>mux_2_to_1.v</span>
                            </div>
                            <span class="text-[10px] text-slate-400">2:1 Mux</span>
                          </div>

                          <div onclick="selectFile('sdc')" class="file-item flex items-center justify-between py-1 px-2 rounded hover:bg-cyan-950/40 cursor-pointer text-slate-300 border border-transparent hover:border-cyan-500/30 transition text-xs">
                            <div class="flex items-center gap-2">
                              <i class="fa-solid fa-clock text-emerald-400"></i>
                              <span>constraint.sdc</span>
                            </div>
                            <span class="text-[10px] text-emerald-400/80 bg-emerald-950 px-1.5 py-0.5 rounded">SDC</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- nangate45/ -->
                  <div class="space-y-1">
                    <div onclick="toggleFolder('nangate-content')" class="flex items-center gap-2 py-1 px-2 rounded hover:bg-slate-800/60 cursor-pointer text-slate-300 transition group">
                      <i id="nangate-icon" class="fa-solid fa-folder-open text-purple-400 text-xs"></i>
                      <span class="font-medium group-hover:text-purple-300">nangate45/</span>
                    </div>

                    <div id="nangate-content" class="pl-4 relative tree-line space-y-1">
                      <div onclick="toggleFolder('csla-pdk-content')" class="flex items-center gap-2 py-1 px-2 rounded hover:bg-slate-800/60 cursor-pointer text-slate-300 transition group">
                        <i id="csla-pdk-icon" class="fa-solid fa-folder-open text-purple-400 text-xs"></i>
                        <span class="font-medium group-hover:text-purple-300">carry_select_adder_16bit/</span>
                      </div>

                      <div id="csla-pdk-content" class="pl-4 relative tree-line space-y-1">
                        <div onclick="selectFile('config_mk')" class="file-item flex items-center justify-between py-1 px-2 rounded hover:bg-purple-950/40 cursor-pointer text-slate-300 border border-transparent hover:border-purple-500/30 transition text-xs">
                          <div class="flex items-center gap-2">
                            <i class="fa-solid fa-gears text-purple-400"></i>
                            <span>config.mk</span>
                          </div>
                          <span class="text-[10px] text-purple-400/80 bg-purple-950 px-1.5 py-0.5 rounded">ORFS Config</span>
                        </div>
                      </div>
                    </div>
                  </div>

                </div>
              </div>

              <!-- README.md -->
              <div onclick="selectFile('readme')" class="file-item flex items-center justify-between py-1 px-2 rounded hover:bg-slate-800/60 cursor-pointer text-slate-300 border border-transparent hover:border-slate-700 transition text-xs">
                <div class="flex items-center gap-2">
                  <i class="fa-solid fa-file-lines text-cyan-400"></i>
                  <span>README.md</span>
                </div>
                <span class="text-[10px] text-slate-400">Documentation</span>
              </div>

            </div>
          </div>
        </div>

        <div class="mt-6 pt-4 border-t border-slate-800/80 text-xs text-slate-400">
          <p class="flex items-center gap-1.5">
            <i class="fa-solid fa-circle-info text-cyan-400"></i>
            <span>Configured for <b>OpenROAD-flow-scripts (ORFS)</b></span>
          </p>
        </div>
      </div>

      <!-- File Content Preview Inspector (7 cols) -->
      <div class="lg:col-span-7 glass-panel rounded-2xl p-5 border border-slate-800 flex flex-col">
        <!-- Inspector Header -->
        <div class="flex items-center justify-between pb-4 border-b border-slate-800 mb-4">
          <div class="flex items-center gap-3">
            <span id="preview-icon" class="p-2 rounded-lg bg-blue-500/10 text-blue-400">
              <i class="fa-solid fa-file-code"></i>
            </span>
            <div>
              <h3 id="preview-title" class="font-bold text-slate-100 text-sm font-mono">carry_select_adder_16bit.v</h3>
              <p id="preview-desc" class="text-xs text-slate-400">Top-Level 16-bit Carry Select Adder Architecture</p>
            </div>
          </div>

          <button onclick="copyCurrentFileContent()" class="text-xs px-2.5 py-1.5 bg-slate-800 hover:bg-slate-700 text-slate-300 rounded-md border border-slate-700 transition flex items-center gap-1.5">
            <i class="fa-solid fa-copy"></i>
            <span>Copy Code</span>
          </button>
        </div>

        <!-- Inspector Content Body -->
        <div class="relative flex-grow bg-[#090d16] rounded-xl border border-slate-800/80 overflow-hidden">
          <pre class="p-4 text-xs font-mono text-slate-300 overflow-x-auto h-96 leading-relaxed" id="code-container">
            <!-- Code injected dynamically via JavaScript -->
          </pre>
        </div>
      </div>

    </div>

    <!-- Graphical Architecture & Flow Diagram -->
    <div class="glass-panel rounded-2xl p-6 border border-slate-800 space-y-6">
      <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-slate-800 pb-4">
        <div>
          <h2 class="text-lg font-bold text-slate-100 flex items-center gap-2">
            <i class="fa-solid fa-diagram-project text-cyan-400"></i>
            <span>16-bit CSLA RTL-to-GDSII Visual Pipeline</span>
          </h2>
          <p class="text-xs text-slate-400">Block-level logic decomposition and Automated ASIC Flow Execution</p>
        </div>
        
        <!-- Tab Controls -->
        <div class="flex items-center p-1 bg-slate-900/90 rounded-lg border border-slate-800 text-xs">
          <button id="tab-btn-arch" onclick="switchDiagramTab('arch')" class="px-3 py-1.5 rounded-md font-medium text-cyan-400 bg-slate-800 shadow transition">CSLA Architecture</button>
          <button id="tab-btn-flow" onclick="switchDiagramTab('flow')" class="px-3 py-1.5 rounded-md font-medium text-slate-400 hover:text-slate-200 transition">ASIC Flow Pipeline</button>
        </div>
      </div>

      <!-- Tab 1: CSLA Architecture Diagram -->
      <div id="tab-arch" class="space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4 relative">
          
          <!-- Block 1 (Bits 3:0) -->
          <div class="bg-slate-900/80 rounded-xl p-4 border border-cyan-500/30 relative overflow-hidden group hover:border-cyan-400 transition">
            <div class="absolute top-0 right-0 px-2 py-0.5 text-[10px] font-mono bg-cyan-950 text-cyan-300 border-b border-l border-cyan-800 rounded-bl">Block 0</div>
            <h4 class="text-xs font-bold text-cyan-400 font-mono mb-2">Bits [3:0]</h4>
            <div class="space-y-2 text-xs">
              <div class="p-2 bg-slate-950 rounded border border-slate-800 text-center font-mono text-slate-300">
                4-bit CLA (Cin=Cin)
              </div>
              <div class="flex justify-between items-center text-[11px] font-mono text-emerald-400 px-1">
                <span>C_out0</span>
                <i class="fa-solid fa-arrow-right"></i>
              </div>
            </div>
          </div>

          <!-- Block 2 (Bits 7:4) -->
          <div class="bg-slate-900/80 rounded-xl p-4 border border-blue-500/30 relative overflow-hidden group hover:border-blue-400 transition">
            <div class="absolute top-0 right-0 px-2 py-0.5 text-[10px] font-mono bg-blue-950 text-blue-300 border-b border-l border-blue-800 rounded-bl">Block 1</div>
            <h4 class="text-xs font-bold text-blue-400 font-mono mb-2">Bits [7:4]</h4>
            <div class="space-y-2 text-xs">
              <div class="grid grid-cols-2 gap-1 text-[10px] font-mono">
                <div class="p-1.5 bg-slate-950 rounded border border-slate-800 text-center text-slate-400">CLA (Cin=0)</div>
                <div class="p-1.5 bg-slate-950 rounded border border-slate-800 text-center text-slate-400">CLA (Cin=1)</div>
              </div>
              <div class="p-2 bg-purple-950/40 rounded border border-purple-800/50 text-center font-mono text-purple-300 text-xs">
                2:1 MUX Array
              </div>
            </div>
          </div>

          <!-- Block 3 (Bits 11:8) -->
          <div class="bg-slate-900/80 rounded-xl p-4 border border-purple-500/30 relative overflow-hidden group hover:border-purple-400 transition">
            <div class="absolute top-0 right-0 px-2 py-0.5 text-[10px] font-mono bg-purple-950 text-purple-300 border-b border-l border-purple-800 rounded-bl">Block 2</div>
            <h4 class="text-xs font-bold text-purple-400 font-mono mb-2">Bits [11:8]</h4>
            <div class="space-y-2 text-xs">
              <div class="grid grid-cols-2 gap-1 text-[10px] font-mono">
                <div class="p-1.5 bg-slate-950 rounded border border-slate-800 text-center text-slate-400">CLA (Cin=0)</div>
                <div class="p-1.5 bg-slate-950 rounded border border-slate-800 text-center text-slate-400">CLA (Cin=1)</div>
              </div>
              <div class="p-2 bg-purple-950/40 rounded border border-purple-800/50 text-center font-mono text-purple-300 text-xs">
                2:1 MUX Array
              </div>
            </div>
          </div>

          <!-- Block 4 (Bits 15:12) -->
          <div class="bg-slate-900/80 rounded-xl p-4 border border-pink-500/30 relative overflow-hidden group hover:border-pink-400 transition">
            <div class="absolute top-0 right-0 px-2 py-0.5 text-[10px] font-mono bg-pink-950 text-pink-300 border-b border-l border-pink-800 rounded-bl">Block 3</div>
            <h4 class="text-xs font-bold text-pink-400 font-mono mb-2">Bits [15:12]</h4>
            <div class="space-y-2 text-xs">
              <div class="grid grid-cols-2 gap-1 text-[10px] font-mono">
                <div class="p-1.5 bg-slate-950 rounded border border-slate-800 text-center text-slate-400">CLA (Cin=0)</div>
                <div class="p-1.5 bg-slate-950 rounded border border-slate-800 text-center text-slate-400">CLA (Cin=1)</div>
              </div>
              <div class="p-2 bg-purple-950/40 rounded border border-purple-800/50 text-center font-mono text-purple-300 text-xs">
                2:1 MUX Array
              </div>
            </div>
          </div>

        </div>
      </div>

      <!-- Tab 2: RTL-to-GDSII Flow Diagram -->
      <div id="tab-flow" class="hidden">
        <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-6 gap-3">
          
          <div class="bg-slate-900 p-3 rounded-xl border border-slate-800 text-center space-y-2">
            <span class="text-xs font-mono font-semibold text-cyan-400">01. Synthesis</span>
            <div class="text-lg text-slate-200"><i class="fa-solid fa-code-merge"></i></div>
            <p class="text-[11px] text-slate-400">Yosys Gate Map</p>
          </div>

          <div class="bg-slate-900 p-3 rounded-xl border border-slate-800 text-center space-y-2">
            <span class="text-xs font-mono font-semibold text-blue-400">02. Floorplan</span>
            <div class="text-lg text-slate-200"><i class="fa-solid fa-vector-square"></i></div>
            <p class="text-[11px] text-slate-400">150×150 µm² Die</p>
          </div>

          <div class="bg-slate-900 p-3 rounded-xl border border-slate-800 text-center space-y-2">
            <span class="text-xs font-mono font-semibold text-purple-400">03. PDN Init</span>
            <div class="text-lg text-slate-200"><i class="fa-solid fa-[#bolt] text-amber-400"></i></div>
            <p class="text-[11px] text-slate-400">VDD/VSS Grid</p>
          </div>

          <div class="bg-slate-900 p-3 rounded-xl border border-slate-800 text-center space-y-2">
            <span class="text-xs font-mono font-semibold text-pink-400">04. Placement</span>
            <div class="text-lg text-slate-200"><i class="fa-solid fa-border-all"></i></div>
            <p class="text-[11px] text-slate-400">Global & Tap Cell</p>
          </div>

          <div class="bg-slate-900 p-3 rounded-xl border border-slate-800 text-center space-y-2">
            <span class="text-xs font-mono font-semibold text-emerald-400">05. CTS & Route</span>
            <div class="text-lg text-slate-200"><i class="fa-solid fa-route"></i></div>
            <p class="text-[11px] text-slate-400">Clock Tree & Track</p>
          </div>

          <div class="bg-slate-900 p-3 rounded-xl border border-emerald-500/40 text-center space-y-2 bg-emerald-950/20">
            <span class="text-xs font-mono font-semibold text-emerald-300">06. GDSII</span>
            <div class="text-lg text-emerald-400"><i class="fa-solid fa-file-export"></i></div>
            <p class="text-[11px] text-emerald-300/80">KLayout Stream</p>
          </div>

        </div>
      </div>

    </div>

    <!-- Raw Markdown Output Box -->
    <div class="glass-panel rounded-2xl p-6 border border-slate-800 space-y-4">
      <div class="flex items-center justify-between border-b border-slate-800 pb-3">
        <div class="flex items-center gap-2">
          <i class="fa-brands fa-markdown text-cyan-400 text-xl"></i>
          <h3 class="font-bold text-slate-100 text-sm">GitHub README Markdown Tree Generator</h3>
        </div>
        <button onclick="copyMarkdownTree()" class="text-xs px-3 py-1.5 bg-slate-800 hover:bg-slate-700 text-slate-200 rounded-lg border border-slate-700 transition flex items-center gap-1.5">
          <i class="fa-solid fa-copy"></i>
          <span>Copy Raw Markdown</span>
        </button>
      </div>

      <pre id="raw-markdown-block" class="p-4 bg-[#090d16] rounded-xl text-xs font-mono text-cyan-300/90 overflow-x-auto border border-slate-800/80 leading-relaxed">
carry-select-adder-16bit-asic/
├── designs/
│   ├── src/
│   │   └── carry_select_adder_16bit/
│   │       ├── carry_select_adder_16bit.v   # Top-level 16-bit CSLA design module
│   │       ├── CLA_adder.v                  # Sub-module: 4-bit Carry Lookahead Adder
│   │       ├── mux_2_to_1.v                 # Sub-module: 2:1 Multiplexer
│   │       └── constraint.sdc               # Synopsys Design Constraints (SDC)
│   └── nangate45/
│       └── carry_select_adder_16bit/
│           └── config.mk                    # OpenROAD flow configuration Makefile
└── README.md                                # Detailed project documentation</pre>
    </div>

  </main>

  <!-- Footer -->
  <footer class="border-t border-slate-800/80 bg-[#060911] py-6">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col sm:flex-row items-center justify-between gap-4 text-xs text-slate-500">
      <div class="flex items-center gap-2">
        <span>Designed for <b>Nangate45nm ASIC Physical Design Flow</b></span>
      </div>
      <div class="flex items-center space-x-4">
        <span>OpenROAD-flow-scripts</span>
        <span>•</span>
        <span>Yosys</span>
        <span>•</span>
        <span>KLayout</span>
      </div>
    </div>
  </footer>

  <!-- Scripts -->
  <script>
    // Mock File contents
    const fileContents = {
      top_v: {
        title: "carry_select_adder_16bit.v",
        icon: "fa-solid fa-file-code",
        iconColor: "text-blue-400",
        desc: "Top-Level 16-bit Carry Select Adder Architecture",
        code: `// Top-Level 16-Bit Carry Select Adder (CSLA)
module carry_select_adder_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] Sum,
    output wire        Cout
);

    wire [3:0] c;
    wire [15:0] sum0, sum1;
    wire [3:0]  cout0, cout1;

    // Block 0: 4-bit CLA with Cin
    CLA_adder cla0 (
        .A(A[3:0]), .B(B[3:0]), .Cin(Cin),
        .Sum(Sum[3:0]), .Cout(c[0])
    );

    // Block 1: Speculative 4-bit CLA (Cin=0 and Cin=1)
    CLA_adder cla1_0 (.A(A[7:4]), .B(B[7:4]), .Cin(1'b0), .Sum(sum0[7:4]), .Cout(cout0[1]));
    CLA_adder cla1_1 (.A(A[7:4]), .B(B[7:4]), .Cin(1'b1), .Sum(sum1[7:4]), .Cout(cout1[1]));
    
    mux_2_to_1 #(.WIDTH(4)) mux1_sum (.in0(sum0[7:4]), .in1(sum1[7:4]), .sel(c[0]), .out(Sum[7:4]));
    mux_2_to_1 #(.WIDTH(1)) mux1_cout (.in0(cout0[1]), .in1(cout1[1]), .sel(c[0]), .out(c[1]));

    // Block 2 & 3: Additional Cascaded Blocks...
    // (Full RTL implemented in main source)

endmodule`
      },
      cla_v: {
        title: "CLA_adder.v",
        icon: "fa-solid fa-file-code",
        iconColor: "text-blue-400",
        desc: "4-bit Carry Lookahead Adder (Sub-module)",
        code: `// 4-bit Carry Lookahead Adder Module
module CLA_adder (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    output wire [3:0] Sum,
    output wire       Cout
);
    wire [3:0] P, G;
    wire [4:0] C;

    assign G = A & B; // Generate
    assign P = A ^ B; // Propagate

    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign Sum  = P ^ C[3:0];
    assign Cout = C[4];
endmodule`
      },
      mux_v: {
        title: "mux_2_to_1.v",
        icon: "fa-solid fa-file-code",
        iconColor: "text-blue-400",
        desc: "Parameterized 2-to-1 Multiplexer",
        code: `// Parameterized 2:1 Multiplexer Module
module mux_2_to_1 #(
    parameter WIDTH = 4
)(
    input  wire [WIDTH-1:0] in0,
    input  wire [WIDTH-1:0] in1,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    assign out = sel ? in1 : in0;
endmodule`
      },
      sdc: {
        title: "constraint.sdc",
        icon: "fa-solid fa-clock",
        iconColor: "text-emerald-400",
        desc: "Synopsys Design Constraints (SDC)",
        code: `# Synopsys Design Constraints (SDC)
current_design carry_select_adder_16bit

# Clock Definition (Virtual Clock for Combinational Constraints)
create_clock -name clk -period 10.0 [get_ports]

# Input / Output Delays
set_input_delay -clock clk 1.5 [all_inputs]
set_output_delay -clock clk 1.5 [all_outputs]

# Load and Driving Cell Configuration
set_driving_cell -lib_cell NBUF_X1 [all_inputs]
set_load 0.05 [all_outputs]`
      },
      config_mk: {
        title: "config.mk",
        icon: "fa-solid fa-gears",
        iconColor: "text-purple-400",
        desc: "OpenROAD Flow Configuration File",
        code: `# OpenROAD Flow Configuration Makefile
export DESIGN_NAME = carry_select_adder_16bit
export PLATFORM    = nangate45

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NAME)/*.v))
export SDC_FILE      = ./designs/src/$(DESIGN_NAME)/constraint.sdc

# Explicit Floorplan Dimensions (Fixes PDN-0185 Initialization Error)
export DIE_AREA  = 0 0 150 150
export CORE_AREA = 5 5 145 145

# Flow Control Settings
export CLOCK_PERIOD = 10.0`
      },
      readme: {
        title: "README.md",
        icon: "fa-solid fa-file-lines",
        iconColor: "text-cyan-400",
        desc: "Project Master Documentation",
        code: `# 16-bit Carry Select Adder (CSLA) - ASIC Flow
Physical Design Implementation using OpenROAD-flow-scripts (ORFS) and Nangate45nm PDK.

## Repository Tree
carry-select-adder-16bit-asic/
├── designs/
│   ├── src/
│   │   └── carry_select_adder_16bit/
│   └── nangate45/
│       └── carry_select_adder_16bit/
└── README.md`
      }
    };

    let activeFileKey = 'top_v';

    // Initialize View
    window.onload = function() {
      selectFile('top_v');
    };

    // Toggle Tree Folder
    function toggleFolder(contentId) {
      const contentEl = document.getElementById(contentId);
      const iconEl = document.getElementById(contentId.replace('-content', '-icon'));
      
      if (contentEl.classList.contains('hidden')) {
        contentEl.classList.remove('hidden');
        if (iconEl) iconEl.className = iconEl.className.replace('fa-folder', 'fa-folder-open');
      } else {
        contentEl.classList.add('hidden');
        if (iconEl) iconEl.className = iconEl.className.replace('fa-folder-open', 'fa-folder');
      }
    }

    // Select File for Code Inspector
    function selectFile(key) {
      activeFileKey = key;
      const fileData = fileContents[key];
      if (!fileData) return;

      document.getElementById('preview-title').innerText = fileData.title;
      document.getElementById('preview-desc').innerText = fileData.desc;
      document.getElementById('code-container').innerText = fileData.code;

      const iconContainer = document.getElementById('preview-icon');
      iconContainer.className = `p-2 rounded-lg bg-slate-800 ${fileData.iconColor}`;
      iconContainer.innerHTML = `<i class="${fileData.icon}"></i>`;
    }

    // Switch Architecture / Flow Diagrams
    function switchDiagramTab(tab) {
      const archTab = document.getElementById('tab-arch');
      const flowTab = document.getElementById('tab-flow');
      const btnArch = document.getElementById('tab-btn-arch');
      const btnFlow = document.getElementById('tab-btn-flow');

      if (tab === 'arch') {
        archTab.classList.remove('hidden');
        flowTab.classList.add('hidden');
        btnArch.className = "px-3 py-1.5 rounded-md font-medium text-cyan-400 bg-slate-800 shadow transition";
        btnFlow.className = "px-3 py-1.5 rounded-md font-medium text-slate-400 hover:text-slate-200 transition";
      } else {
        archTab.classList.add('hidden');
        flowTab.classList.remove('hidden');
        btnFlow.className = "px-3 py-1.5 rounded-md font-medium text-cyan-400 bg-slate-800 shadow transition";
        btnArch.className = "px-3 py-1.5 rounded-md font-medium text-slate-400 hover:text-slate-200 transition";
      }
    }

    // Toast Notification
    function showToast(message) {
      const toast = document.getElementById('toast');
      document.getElementById('toast-msg').innerText = message;
      toast.classList.remove('opacity-0', 'pointer-events-none', 'translate-y-4');
      toast.classList.add('opacity-100', 'translate-y-0');

      setTimeout(() => {
        toast.classList.remove('opacity-100', 'translate-y-0');
        toast.classList.add('opacity-0', 'pointer-events-none', 'translate-y-4');
      }, 2500);
    }

    // Copy Current File Content
    function copyCurrentFileContent() {
      const codeText = document.getElementById('code-container').innerText;
      copyToClipboard(codeText);
      showToast('File content copied to clipboard!');
    }

    // Copy Raw Markdown Tree
    function copyMarkdownTree() {
      const mdTree = document.getElementById('raw-markdown-block').innerText;
      copyToClipboard(mdTree);
      showToast('Markdown tree copied!');
    }

    // Clipboard Fallback
    function copyToClipboard(text) {
      const textArea = document.createElement('textarea');
      textArea.value = text;
      document.body.appendChild(textArea);
      textArea.select();
      try {
        document.execCommand('copy');
      } catch (err) {
      console.error('Fallback: Copying failed', err);
      }
      document.body.removeChild(textArea);
    }
  </script>

</body>
</html>
