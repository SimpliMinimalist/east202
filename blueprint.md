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

## Current Requested Change: UI/UX Bug Fixes & Theming

### Plan and Steps
- **Goal:** Address several UI/UX bugs and apply theme consistency.
- **Steps Taken:**
  1.  **Fixed Bottom Sheet Display:**
      - **Issue:** The "Add New Category" bottom sheet was appearing underneath the main `AppBar` and `BottomNavigationBar`, instead of as an overlay.
      - **Solution:** Modified the `showModalBottomSheet` call in `lib/features/store/widgets/add_category_bottom_sheet.dart` by setting `useRootNavigator: true`.
  2.  **Fixed Full-Screen Page Navigation:**
      - **Issue:** The "Add/Edit Product" screen (`AddProductScreen`) was opening within the main app shell, leaving the top and bottom navigation bars visible.
      - **Solution:** Updated the navigation logic to use the root navigator by calling `Navigator.of(context, rootNavigator: true).push(...)` in `lib/features/store/screens/store_screen.dart` and `lib/core/navigation/main_shell.dart`.
  3.  **Themed Clear Icon:**
      - **Issue:** The clear text icon in `ClearableTextFormField` had a hardcoded color.
      - **Solution:** Modified `lib/shared/widgets/clearable_text_form_field.dart` to use `Theme.of(context).colorScheme.primary` for the icon color, ensuring it matches the app's theme.
  4.  **Fixed Status Bar Overlap:**
      - **Issue:** The search bar and content on the Store and Orders screens were overlapping with the system status bar.
      - **Solution:** Wrapped the body of `lib/features/store/screens/store_screen.dart` and `lib/features/orders/screens/orders_screen.dart` with a `SafeArea` widget.