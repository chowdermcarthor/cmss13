
///////////////////////////////////////Stock Parts /////////////////////////////////

//stock parts for constructable machines

/obj/item/stock_parts
	name = "stock part"
	desc = "What?"
	gender = PLURAL
	icon = 'icons/obj/items/stock_parts.dmi'
	w_class = SIZE_SMALL
	var/rating = 1

/obj/item/stock_parts/Initialize()
	. = ..()
	src.pixel_x = rand(-5.0, 5)
	src.pixel_y = rand(-5.0, 5)

//Rank 1

/obj/item/stock_parts/console_screen
	name = "console screen"
	desc = "Used in the construction of computers and other devices with an interactive console."
	icon_state = "screen"

	matter = list("glass" = 200)

/obj/item/stock_parts/capacitor
	name = "capacitor"
	desc = "A basic capacitor used in the construction of a variety of devices."
	icon_state = "capacitor"

	matter = list("metal" = 50,"glass" = 50)

/obj/item/stock_parts/scanning_module
	name = "scanning module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "scan_module"

	matter = list("metal" = 50,"glass" = 20)

/obj/item/stock_parts/manipulator
	name = "micro-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "micro_mani"

	matter = list("metal" = 30)

/obj/item/stock_parts/micro_laser
	name = "micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "micro_laser"

	matter = list("metal" = 10,"glass" = 20)

/obj/item/stock_parts/matter_bin
	name = "matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "matter_bin"

	matter = list("metal" = 80)

//Rank 2

/obj/item/stock_parts/capacitor/adv
	name = "advanced capacitor"
	desc = "An advanced capacitor used in the construction of a variety of devices."

	rating = 2
	matter = list("metal" = 50,"glass" = 50)

/obj/item/stock_parts/scanning_module/adv
	name = "advanced scanning module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "scan_module"

	rating = 2
	matter = list("metal" = 50,"glass" = 20)

/obj/item/stock_parts/manipulator/nano
	name = "nano-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "nano_mani"

	rating = 2
	matter = list("metal" = 30)

/obj/item/stock_parts/micro_laser/high
	name = "high-power micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "high_micro_laser"

	rating = 2
	matter = list("metal" = 10,"glass" = 20)

/obj/item/stock_parts/matter_bin/adv
	name = "advanced matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "advanced_matter_bin"

	rating = 2
	matter = list("metal" = 80)

//Rating 3

/obj/item/stock_parts/capacitor/super
	name = "super capacitor"
	desc = "A super-high-capacity capacitor used in the construction of a variety of devices."

	rating = 3
	matter = list("metal" = 50,"glass" = 50)

/obj/item/stock_parts/scanning_module/phasic
	name = "phasic scanning module"
	desc = "A compact, high resolution phasic scanning module used in the construction of certain devices."

	rating = 3
	matter = list("metal" = 50,"glass" = 20)

/obj/item/stock_parts/manipulator/pico
	name = "pico-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "pico_mani"

	rating = 3
	matter = list("metal" = 30)

/obj/item/stock_parts/micro_laser/ultra
	name = "ultra-high-power micro-laser"
	icon_state = "ultra_high_micro_laser"
	desc = "A tiny laser used in certain devices."

	rating = 3
	matter = list("metal" = 10,"glass" = 20)

/obj/item/stock_parts/matter_bin/super
	name = "super matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "super_matter_bin"

	rating = 3
	matter = list("metal" = 80)

// Subspace stock parts

/obj/item/stock_parts/subspace/ansible
	name = "subspace ansible"
	icon_state = "subspace_ansible"
	desc = "A compact module capable of sensing extradimensional activity."

	matter = list("metal" = 30,"glass" = 10)

/obj/item/stock_parts/subspace/filter
	name = "hyperwave filter"
	icon_state = "hyperwave_filter"
	desc = "A tiny device capable of filtering and converting super-intense radio waves."

	matter = list("metal" = 30,"glass" = 10)

/obj/item/stock_parts/subspace/amplifier
	name = "subspace amplifier"
	icon_state = "subspace_amplifier"
	desc = "A compact micro-machine capable of amplifying weak subspace transmissions."

	matter = list("metal" = 30,"glass" = 10)

/obj/item/stock_parts/subspace/treatment
	name = "subspace treatment disk"
	icon_state = "treatment_disk"
	desc = "A compact micro-machine capable of stretching out hyper-compressed radio waves."

	matter = list("metal" = 30,"glass" = 10)

/obj/item/stock_parts/subspace/analyzer
	name = "subspace wavelength analyzer"
	icon_state = "wavelength_analyzer"
	desc = "A sophisticated analyzer capable of analyzing cryptic subspace wavelengths."

	matter = list("metal" = 30,"glass" = 10)

/obj/item/stock_parts/subspace/crystal
	name = "ansible crystal"
	icon_state = "ansible_crystal"
	desc = "A crystal made from pure glass used to transmit laser data bursts to subspace."

	matter = list("glass" = 50)

/obj/item/stock_parts/subspace/transmitter
	name = "subspace transmitter"
	icon_state = "subspace_transmitter"
	desc = "A large piece of equipment used to open a window into the subspace dimension."

	matter = list("metal" = 50)



//Construction Item for the SMES
/obj/item/stock_parts/smes_coil
	name = "Superconducting Magnetic Coil"
	desc = "Heavy-duty superconducting magnetic coil, mainly used in construction of SMES units."
	icon_state = "smes_coil" // Just few icons patched together. If someone wants to make better icon, feel free to do so!
	w_class = SIZE_LARGE // It's LARGE (backpack size)
	var/ChargeCapacity = 5000000
	var/IOCapacity = 250000

