import sys

# case where we are not in a virtual environment
if sys.prefix == sys.base_prefix:
  print("NO")

# case where we are in a virtual environment
else:
  print("YES")

