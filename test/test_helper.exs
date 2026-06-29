ExUnit.start()

# This makes sure your application and all dependencies are started
Application.ensure_all_started(:cjk_double_stroke)

# Connect to the dedicated DB node (required for StaticData)
CjkDoubleStroke.DBClient.connect()

# Requires the dedicated DB node to be connected first.
# See the "Fast iteration workflow" section in the README.
CjkDoubleStroke.Datagenerators.StaticData.init()
