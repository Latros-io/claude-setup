# Data Science Domain

**Version:** 1.0.0
**Status:** Planned (0 of 14 components implemented)
**Category:** Data Analysis, Machine Learning, Scientific Computing

## Overview

The Data Science domain provides specialized components for data analysis, machine learning, and scientific computing workflows. It extends the core Claude Code components with data science-specific agents, skills, rules, and settings optimized for working with Jupyter notebooks, pandas, NumPy, scikit-learn, PyTorch, TensorFlow, and other data science tools.

This domain is designed for teams working on:
- Exploratory data analysis (EDA)
- Machine learning model development
- Data visualization and reporting
- Scientific computing and simulations
- MLOps and model deployment

## Components

### Agents (0 of 2 planned)

| Agent | Status | Purpose |
|-------|--------|---------|
| **DataAnalyst** | Planned | EDA, visualization, statistical analysis, pandas/NumPy expert |
| **MLEngineer** | Planned | Model training, hyperparameter tuning, PyTorch/TensorFlow |

**DataAnalyst Agent** (Planned)
- Expert in pandas, NumPy, matplotlib, seaborn, plotly
- Statistical analysis and hypothesis testing
- Data cleaning and transformation
- Feature engineering
- Jupyter notebook workflows
- Reproducible analysis practices

**MLEngineer Agent** (Planned)
- Model architecture design (PyTorch, TensorFlow, scikit-learn)
- Training pipelines and experiment tracking
- Hyperparameter optimization
- Model evaluation and validation
- Transfer learning and fine-tuning
- Model deployment preparation

### Skills (0 of 5 planned)

| Skill | Status | Purpose |
|-------|--------|---------|
| **jupyter-workflow** | Planned | Manage notebooks, cell execution, kernel management |
| **data-viz-gen** | Planned | Generate publication-quality visualizations |
| **model-trainer** | Planned | Automated model training with experiment tracking |
| **dataset-validator** | Planned | Validate data quality and schema compliance |
| **notebook-exporter** | Planned | Export notebooks to HTML, PDF, scripts |

### Rules (0 of 4 planned)

| Rule | Status | Purpose |
|------|--------|---------|
| **reproducibility** | Planned | Seed fixing, environment management, versioning |
| **data-validation** | Planned | Schema validation, missing value handling, outlier detection |
| **notebook-quality** | Planned | Cell organization, documentation, output clearing |
| **ml-best-practices** | Planned | Train/test split, cross-validation, metric selection |

### Settings Profiles (0 of 3 planned)

| Profile | Status | Purpose |
|---------|--------|---------|
| **pandas-numpy.json** | Planned | Data analysis with pandas, NumPy, matplotlib |
| **pytorch.json** | Planned | Deep learning with PyTorch, TorchVision |
| **tensorflow.json** | Planned | Deep learning with TensorFlow, Keras |

## Use Cases

### Exploratory Data Analysis

**Typical workflow with DataAnalyst agent** (when implemented)

Example tasks:
- "Load CSV, explore shape, check for missing values, generate summary statistics"
- "Create correlation matrix and visualize with seaborn heatmap"
- "Identify outliers using IQR method and visualize with box plots"
- "Generate automated EDA report with distributions and relationships"

### Machine Learning Development

**Typical workflow with MLEngineer agent** (when implemented)

Example tasks:
- "Build binary classifier with scikit-learn, evaluate with ROC-AUC"
- "Create PyTorch CNN for image classification with data augmentation"
- "Implement hyperparameter tuning with Optuna or Ray Tune"
- "Add experiment tracking with Weights & Biases or MLflow"

### Notebook Management

**Typical workflow with jupyter-workflow skill** (when implemented)

Example tasks:
- "Clean notebook outputs before committing to git"
- "Convert notebook to Python script with cell markers"
- "Execute notebook programmatically and save results"
- "Merge multiple analysis notebooks into report"

## Integration Instructions

### Quick Start (When Implemented)

**1. Add submodule** (if not already added)
```bash
cd your-data-science-project
git submodule add https://github.com/Latros-io/claude-code-best-practices.git .claude/best-practices
git submodule update --init --recursive
```

**2. Link data science components**
```bash
.claude/best-practices/scripts/link.sh --profile=data-science
```

This will create symlinks for:
- Core agents (Bash, Explore, Plan)
- DataAnalyst and MLEngineer agents
- Core skills (git-workflow, test-runner, doc-generator)
- Data science skills (jupyter-workflow, model-trainer, etc.)
- Core + data science rules

**3. Apply data science settings**
```bash
# For pandas/numpy workflows
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/data-science/settings/pandas-numpy.json \
    .claude/settings.json

# Or for PyTorch workflows
.claude/best-practices/scripts/merge-settings.sh \
    .claude/best-practices/core/settings/standard.json \
    .claude/best-practices/domains/data-science/settings/pytorch.json \
    .claude/settings.json
```

**4. Commit changes**
```bash
git add .claude .github
git commit -m "Add Claude Code best practices (data-science)"
```

## Configuration Options (Planned)

### Pandas-NumPy Profile

Expected configuration areas:

**Data Processing**
- pandas display options (max_rows, max_columns)
- NumPy print options
- Memory optimization settings
- Chunk processing for large datasets

**Visualization**
- Default plotting backend (matplotlib, plotly)
- Style themes and color palettes
- Figure size and DPI settings
- Interactive vs static plots

**Jupyter**
- Auto-reload extensions
- Variable inspector
- Execution time display
- Output formatting

**Data Validation**
- Schema enforcement
- Type checking
- Missing value policies
- Range validation rules

### PyTorch Profile

Expected configuration areas:

**Training**
- Default device (CPU, CUDA, MPS)
- Mixed precision training
- Gradient accumulation
- Checkpoint frequency

**Experiment Tracking**
- Tool: Weights & Biases, MLflow, or TensorBoard
- Metrics to log
- Artifact storage
- Hyperparameter search

**Model Development**
- Default initialization schemes
- Loss functions and optimizers
- Learning rate schedulers
- Data augmentation pipelines

**Reproducibility**
- Random seed management
- Deterministic algorithms
- Environment specification
- Dataset versioning

## Examples (Planned)

### Example 1: Automated EDA

**Task:** "Analyze customer_data.csv and generate insights"

**DataAnalyst agent will:**
1. Load CSV with pandas, display shape and dtypes
2. Check for missing values and duplicates
3. Generate summary statistics for numerical columns
4. Create distribution plots for key features
5. Compute correlation matrix and visualize
6. Identify potential data quality issues
7. Export findings to markdown report

### Example 2: Train Classification Model

**Task:** "Build a binary classifier to predict churn"

**MLEngineer agent will:**
1. Load and split data (train/validation/test)
2. Perform feature engineering and scaling
3. Try multiple algorithms (LogisticRegression, RandomForest, XGBoost)
4. Evaluate with precision, recall, F1, ROC-AUC
5. Perform hyperparameter tuning on best model
6. Generate classification report and confusion matrix
7. Save model with versioning

### Example 3: Deep Learning Image Classifier

**Task:** "Create CNN for CIFAR-10 classification with PyTorch"

**MLEngineer agent will:**
1. Set up data loaders with augmentation
2. Define CNN architecture (conv layers, pooling, FC)
3. Configure training loop with validation
4. Add learning rate scheduler
5. Implement early stopping
6. Log metrics to Weights & Biases
7. Save checkpoints and best model
8. Generate evaluation plots (loss curves, accuracy)

## Dependencies

### Required Core Components

The data science domain extends these core components:
- **Agents**: Bash, Explore, Plan (all required)
- **Skills**: git-workflow (recommended)
- **Rules**: code-style, documentation (recommended)

### Python Environment

**Required:**
- Python 3.9+
- pip or conda for package management
- Jupyter Lab or Jupyter Notebook

**Common packages:**
- pandas, NumPy, matplotlib, seaborn
- scikit-learn for ML
- PyTorch or TensorFlow for deep learning
- Jupyter, ipykernel

### MCP Servers (Optional)

Useful MCP servers for data science:
- **filesystem**: Navigate datasets and notebooks
- **postgres**: Direct database access for data loading
- **github**: Version control for notebooks and models

## Roadmap

### v1.0.0 - Planning Phase (Current)
- Design DataAnalyst and MLEngineer agents
- Define skill specifications
- Create settings profiles
- Document use cases

### v1.1.0 - Data Analysis Ready (Q3 2026)
- ✅ DataAnalyst agent
- ✅ jupyter-workflow skill
- ✅ data-viz-gen skill
- ✅ dataset-validator skill
- ✅ reproducibility rules
- ✅ notebook-quality rules
- ✅ pandas-numpy.json settings

### v1.2.0 - ML Complete (Q4 2026)
- ✅ MLEngineer agent
- ✅ model-trainer skill
- ✅ ml-best-practices rules
- ✅ pytorch.json and tensorflow.json settings
- ✅ notebook-exporter skill

### v1.3.0 - Advanced Features (Q1 2027)
- AutoML integration
- Distributed training support
- Model serving and deployment
- Advanced visualization dashboards

## Best Practices (Future Rules)

### Reproducibility
- Always set random seeds (NumPy, PyTorch, TensorFlow, Python)
- Pin package versions in requirements.txt or environment.yml
- Document data sources and preprocessing steps
- Version datasets with DVC or similar tools

### Notebook Quality
- Clear section headers with markdown cells
- Remove or minimize print debugging
- Clear outputs before committing to git
- Include requirements and setup instructions
- Add docstrings to custom functions

### Data Validation
- Validate schema before processing
- Handle missing values explicitly
- Check for data leakage between train/test
- Document assumptions about data distribution

### Model Development
- Always use train/validation/test split
- Track experiments with MLflow or W&B
- Save model checkpoints regularly
- Document model architecture and hyperparameters
- Evaluate multiple metrics, not just accuracy

## Contributing

We welcome contributions to the data science domain!

**Needed components (all planned):**
- DataAnalyst agent
- MLEngineer agent
- Skills: jupyter-workflow, data-viz-gen, model-trainer, dataset-validator, notebook-exporter
- Rules: reproducibility, data-validation, notebook-quality, ml-best-practices
- Settings: pandas-numpy.json, pytorch.json, tensorflow.json

**How to contribute:**
1. Check [CONTRIBUTING.md](../../CONTRIBUTING.md) for guidelines
2. Follow existing component structure (AGENT.md, config.json, etc.)
3. Include examples with real datasets or notebooks
4. Add comprehensive documentation
5. Update this README with new components

## Support

- **Documentation**: See [INTEGRATION.md](../../INTEGRATION.md) for general integration
- **Issues**: [GitHub Issues](https://github.com/Latros-io/claude-code-best-practices/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Latros-io/claude-code-best-practices/discussions)

## License

MIT License - see [LICENSE](../../LICENSE)

---

**Last Updated:** 2026-01-19
**Maintainer:** Claude Code Best Practices Team
**Status:** Accepting design feedback and contributions
