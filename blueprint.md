# E-Commerce Admin Panel Blueprint

## Overview

A Flutter-based mobile application for e-commerce administrators to manage their products. The application provides functionalities for adding, editing, and organizing products, including support for product variants and draft management.

## Style, Design, and Features Implemented

### Core Functionality
- **Product Management:**
  - Create, edit, and publish products.
  - Fields for product name, description, price, sale price, and stock quantity.
- **Image Management:**
  - Add up to 10 images per product from the device's gallery.
  - An interactive image carousel to view and remove uploaded images.
- **Category Management:**
  - Assign products to one or more categories.
  - Ability to add new categories on the fly from the product editing screen.
- **Draft System:**
  - Save products as drafts to finish later.
  - A limit of up to 5 drafts can be stored.
  - A drafts popup allows users to view, load, and manage existing drafts.
  - Automatic prompts to save changes as a draft when leaving a modified product form.
- **Product Variants:**
  - Define product options (e.g., Size, Color).
  - Add multiple values for each option (e.g., Small, Medium, Large for Size).
  - Automatically generate all possible variant combinations.
  - A dedicated screen to edit the price, stock, and image for each individual variant.
  - A list of variants is displayed on the main product form.

### UI/UX Design
- **Modern Aesthetics:**
  - Clean and intuitive user interface.
  - Use of `Material Design 3` principles.
  - Clear and readable typography.
- **Responsive Layout:**
  - The application is designed to be responsive and work well on various screen sizes.
- **Interactive Elements:**
  - `ClearableTextFormField` for easy input clearing. The clear icon now uses the app's primary color for a consistent look.
  - Smooth page indicators for image carousels.
  - Modals and bottom sheets for interactive category and draft selection.
- **Navigation:**
  - A `PopScope` is used to prevent accidental data loss by prompting users to save changes before navigating away.
  - Seamless navigation between the product list, product editor, and variant editor.

## Current Requested Change: Store Screen UX and FAB Animation

### Plan and Steps
- **Goal:** Improve the user experience on the store screen and remove the default animation from the Floating Action Button (FAB).
- **Steps Taken:**
  1.  **Resolved FAB Confusion:**
      - **Issue:** The main "Add Product" FAB was correctly located in the `MainShell`, but a confusing `+` button for adding *categories* existed on the `StoreScreen`, creating a conflicting user experience. Additionally, the empty state "Add one!" text was not interactive.
      - **Solution:**
        - The misleading "Add Category" `ChoiceChip` was removed from the horizontal filter list in `lib/features/store/screens/store_screen.dart`.
        - The empty state message ("No products yet. Add one!") was converted into a large, tappable call-to-action that navigates to the "Add Product" screen.
  2.  **Disabled FAB Animation:**
      - **Issue:** The FAB had a default rotation and fade animation when appearing/disappearing between tabs.
      - **Solution:** Wrapped the `FloatingActionButton` in `lib/core/navigation/main_shell.dart` with an `AnimatedSwitcher` and set the `duration` to `Duration.zero` to make the transition instant.
