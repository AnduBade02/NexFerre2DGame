extends Node

var pages_collected: int = 0
var collected_pages := {}  # dictionar: note_ui_index -> true

func collect_page(index: int):
	if not collected_pages.has(index):
		collected_pages[index] = true
		pages_collected += 1
		print("✅ Pagini colectate:", pages_collected)

func uncollect_all():
	collected_pages.clear()
	pages_collected = 0
	print("🔄 Resetare! Pagini colectate: 0")
