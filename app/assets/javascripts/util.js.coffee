# Global Scope
root = exports ? this

gc.util =
	# Format numbers with commas and decimals.
	formatNumber: (num) ->
		x = num.toFixed(2)
		parts = x.toString().split(".")
		parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",")
		parts.join(".")