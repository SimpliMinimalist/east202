# Project Blueprint

## Overview

A Flutter application for managing products and orders.

## Project Structure

The project follows a feature-based folder structure.

-   `lib/features/auth`: Authentication-related features.
-   `lib/features/orders`: Order management features.
    -   `lib/features/orders/search_orders`: Search functionality for orders.
-   `lib/features/profile`: User profile management.
-   `lib/features/store`: Store management features.
    -   `lib/features/store/add_product`: Feature for adding and editing products.
    -   `lib/features/store/providers`: Contains providers for the store feature.
    -   `lib/features/store/search_product`: Feature for searching products.
    -   `lib/features/store/store_setup`: Feature for setting up the store.

## Features Implemented

### Add/Edit Product Screen
-   Allows creating and editing products.
-   Image picker for adding up to 10 product images.
-   Fields for product name, price, category, stock, and description.
-   Ability to add product variants.
-   Draft saving functionality.
-   Sale price functionality with a bottom sheet for input.
-   Display of the original price with a strikethrough when a sale price is active.
-   "Add discount" button is disabled until a valid price is entered.
-   "Add discount" button text changes to "Edit discount" when a sale price is active.

## Current Change: Fix Sale Price Bottom Sheet Overlap

-   **Goal:** Prevent the keyboard from overlapping the sale price input bottom sheet.
-   **Steps:**
    1.  Modified `_showSalePriceBottomSheet` in `add_product_screen.dart`.
    2.  Set `isScrollControlled: true` on the `showModalBottomSheet` widget.
    3.  Added `EdgeInsets` to account for the keyboard's view insets, ensuring the bottom sheet is always visible.
    4. Corrected a typo from `_edited` to `_editedProduct`
