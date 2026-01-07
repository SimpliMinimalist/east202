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
-   Character limit for product name and description fields is only shown on focus.
-   Ability to add product variants.
-   "Add Product Variants" button width is now based on its content and centered.
-   Draft saving functionality.
-   Sale price functionality with a dedicated bottom sheet widget (`SalePriceBottomSheet`).
-   Display of the original price with a strikethrough when a sale price is active.
-   "Add discount" button is disabled until a valid price is entered.
-   "Add discount" button text changes to "Edit discount" when a sale price is active.
-   Sale price input validation to ensure the sale price is less than the original price.
-   The "Done" button in the sale price bottom sheet is disabled if the validation fails.
-   The sale price is automatically cleared if the bottom sheet is dismissed with an invalid value.
-   The sale price bottom sheet is scroll-controlled to avoid keyboard overlap.
-   Corrected a typo from `_editedDitedProduct` to `_editedProduct`.

## Current Change: UI Adjustments and Bug Fix

-   **Goal:** Improve the user interface by adjusting the character limit display, modifying the variant button width, and fixing a typo.
-   **Steps:**
    1.  Modified `ClearableTextFormField` to only show the character counter when the text field is focused.
    2.  Adjusted the "Add Product Variants" button in `add_product_screen.dart` to automatically size based on its content and be centered.
    3.  Corrected a typo from `_editedDitedProduct` to `_editedProduct` in `add_product_screen.dart`.
